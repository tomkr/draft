defmodule Draft.Ranges do
  defmacro __using__(_) do
    quote do
      @moduledoc """
      Provides functions for adding inline style ranges and entity ranges
      """

      def apply_ranges(text, inline_style_ranges, entity_ranges, entity_map, context) do
        inline_style_ranges ++ entity_ranges
        |> consolidate_ranges()
        |> Enum.reduce(text, fn {start, finish}, acc ->
          {style_opening_tag, style_closing_tag} =
            case get_styles_for_range(start, finish, inline_style_ranges, context) do
              "" -> {"", ""}
              styles -> {"<span style=\"#{styles}\">", "</span>"}
            end
          entity_opening_tags = get_entity_opening_tags_for_start(start, entity_ranges, entity_map, context)
          entity_closing_tags = get_entity_closing_tags_for_finish(finish, entity_ranges, entity_map, context)
          opening_tags = "#{entity_opening_tags}#{style_opening_tag}"
          closing_tags = "#{style_closing_tag}#{entity_closing_tags}"

          adjusted_start = start + String.length(acc) - String.length(text)
          adjusted_finish = finish + String.length(acc) - String.length(text)

          acc
          |> String.split_at(adjusted_finish)
          |> Tuple.to_list
          |> Enum.join(closing_tags)
          |> String.split_at(adjusted_start)
          |> Tuple.to_list
          |> Enum.join(opening_tags)
        end)
      end

      def process_style("BOLD", _) do
        "font-weight: bold;"
      end

      def process_style("ITALIC", _) do
        "font-style: italic;"
      end

      def process_entity(%{"type"=>"LINK","mutability"=>"MUTABLE","data"=>%{"url"=>url}}, _) do
        {"<a href=\"#{url}\">", "</a>"}
      end

      defp get_styles_for_range(start, finish, inline_style_ranges, context) do
        inline_style_ranges
        |> Enum.filter(fn range -> is_in_range(range, start, finish) end)
        |> Enum.map(fn range -> process_style(range["style"], context) end)
        |> Enum.join(" ")
      end

      defp get_entity_opening_tags_for_start(start, entity_ranges, entity_map, context) do
        entity_ranges
        |> Enum.filter(fn range -> range["offset"] === start end)
        |> Enum.map(fn range -> Map.get(entity_map, Integer.to_string(range["key"])) |> process_entity(context) |> elem(0) end)
      end

      defp get_entity_closing_tags_for_finish(finish, entity_ranges, entity_map, context) do
        entity_ranges
        |> Enum.filter(fn range -> range["offset"] + range["length"] === finish end)
        |> Enum.map(fn range -> Map.get(entity_map, Integer.to_string(range["key"])) |> process_entity(context) |> elem(1) end)
        |> Enum.reverse()
      end

      defp is_in_range(range, start, finish) do
        range_start = range["offset"]
        range_finish = range["offset"] + range["length"]

        start >= range_start && finish <= range_finish
      end

      @doc """
      Takes multiple potentially overlapping ranges and breaks them into other mutually exclusive
      ranges, so we can take each mini-range and add the specified, potentially multiple, styles
      and entities to each mini-range

      ## Examples
          iex> ranges = [
            %{"offset" => 0, "length" => 4, "style" => "ITALIC"},
            %{"offset" => 4, "length" => 4, "style" => "BOLD"},
            %{"offset" => 2, "length" => 3, "key" => 0}]
          iex> consolidate_ranges(ranges)
          [{0, 2}, {2, 4}, {4, 5}, {5, 8}]
      """
      defp consolidate_ranges(ranges) do
        ranges
        |> ranges_to_points()
        |> points_to_ranges()
      end

      defp points_to_ranges(points) do
        points
        |> Enum.with_index
        |> Enum.reduce([], fn {point, index}, acc ->
          case Enum.at(points, index + 1) do
            nil -> acc
            next -> acc ++ [{point, next}]
          end
        end)
      end

      defp ranges_to_points(ranges) do
        Enum.reduce(ranges, [], fn range, acc ->
          acc ++ [range["offset"], range["offset"] + range["length"]]
        end)
        |> Enum.uniq
        |> Enum.sort
      end
    end
  end
end
