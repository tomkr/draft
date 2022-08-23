defmodule Draft.Ranges do
  defmacro __using__(_) do
    quote do
      @moduledoc """
      Provides functions for adding inline style ranges and entity ranges
      """

      def apply_ranges(block, entity_map, context) do
        block["inlineStyleRanges"]
        |> divvy_style_ranges(block["entityRanges"])
        |> group_style_ranges()
        |> Kernel.++(block["entityRanges"])
        |> sort_by_offset_and_length_then_styles(entity_map)
        |> DraftTree.build_tree(block["text"])
        |> DraftTree.process_tree(fn text, styles, key ->
          cond do
            !is_nil(styles) ->
              css =
                styles
                |> Enum.map(fn style -> process_style(style, context) end)
                |> Enum.join(" ")

              "<span style=\"#{css}\">#{text}</span>"

            !is_nil(key) ->
              process_entity(entity_map |> Map.get(Integer.to_string(key)), text, context)

            true ->
              text
          end
        end)
      end

      def process_style("BOLD", _) do
        "font-weight: bold;"
      end

      def process_style("ITALIC", _) do
        "font-style: italic;"
      end

      def process_style("UNDERLINE", _) do
        "text-decoration: underline;"
      end

      # NB: styling will be processed first
      # This fixes a bug in Outlook where a `span`'s styling has no effect on the `a` tag.
      # So instead of `<span style="font-family: Comic Sans MS, sans-serif;"><a href="https="www.google.com">Google</a></span>` we want
      # `<a href="https="www.google.com"><span style="font-family: Comic Sans MS, sans-serif;">Google</span></a>`
      def process_style_order(range, %{
            "type" => "LINK",
            "mutability" => "MUTABLE",
            "data" => _data
          }) do
        !is_nil(range["styles"])
      end

      # NB: styling will be processed last
      def process_style_order(range, _entity) do
        is_nil(range["styles"])
      end

      def process_entity(
            %{"type" => "LINK", "mutability" => "MUTABLE", "data" => %{"url" => url}},
            text,
            _
          ) do
        "<a href=\"#{url}\">#{text}</a>"
      end

      defp group_style_ranges(ranges) do
        ranges
        |> Enum.group_by(fn range -> {range["offset"], range["length"]} end)
        |> Enum.map(fn {{offset, length}, ranges} ->
          %{"offset" => offset, "length" => length, "styles" => ranges |> Enum.map(& &1["style"])}
        end)
      end

      @doc """
      Cuts up multiple potentially overlapping ranges into more mutually exclusive ranges
      """
      def divvy_style_ranges(style_ranges, entity_ranges) do
        Enum.map(style_ranges, fn style_range ->
          ranges_to_points(entity_ranges ++ style_ranges)
          |> Enum.filter(fn point ->
            point > style_range["offset"] && point < style_range["offset"] + style_range["length"]
          end)
          |> Enum.reduce([style_range], fn point, acc ->
            {already_split, [main]} = Enum.split(acc, length(acc) - 1)

            already_split ++
              [
                %{
                  "style" => style_range["style"],
                  "offset" => main["offset"],
                  "length" => point - main["offset"]
                },
                %{
                  "style" => style_range["style"],
                  "offset" => point,
                  "length" => main["length"] - (point - main["offset"])
                }
              ]
          end)
        end)
        |> List.flatten()
      end

      defp sort_by_offset_and_length_then_styles(ranges, entity_map) do
        ranges
        |> Enum.sort(fn range1, range2 ->
          cond do
            range1["offset"] != range2["offset"] ->
              range1["offset"] < range2["offset"]

            range1["length"] != range2["length"] ->
              range1["length"] >= range2["length"]

            true ->
              key =
                case range2["key"] do
                  nil -> nil
                  key -> Integer.to_string(key)
                end

              entity = Map.get(entity_map, key)

              process_style_order(range2, entity)
          end
        end)
      end

      defp ranges_to_points(ranges) do
        Enum.reduce(ranges, [], fn range, acc ->
          acc ++ [range["offset"], range["offset"] + range["length"]]
        end)
        |> Enum.uniq()
        |> Enum.sort()
      end
    end
  end
end
