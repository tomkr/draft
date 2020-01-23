defmodule Draft.Block do
  defmacro __using__(_) do
    quote do
      @moduledoc """
      Converts a single DraftJS block to html.
      """

      use Draft.Ranges

      def process_block(%{"type" => "unstyled", "text" => ""}, _, _) do
        "<br>"
      end

      def process_block(
            %{"type" => "header-" <> header, "text" => text} = block,
            entity_map,
            context
          ) do
        tag = header_tags()[header]
        "<#{tag}>#{apply_ranges(block, entity_map, context)}</#{tag}>"
      end

      def process_block(%{"type" => "blockquote", "text" => text} = block, entity_map, context) do
        "<blockquote>#{apply_ranges(block, entity_map, context)}</blockquote>"
      end

      def process_block(%{"type" => "unstyled", "text" => text} = block, entity_map, context) do
        "<p>#{apply_ranges(block, entity_map, context)}</p>"
      end

      def process_block(
            %{"type" => "unordered-list", "data" => %{"children" => children}},
            entity_map,
            context
          ) do
        "<ul>#{Enum.map(children, &process_block(&1, entity_map, context)) |> Enum.join("\n")}</ul>"
      end

      def process_block(
            %{"type" => "ordered-list", "data" => %{"children" => children}},
            entity_map,
            context
          ) do
        "<ol>#{Enum.map(children, &process_block(&1, entity_map, context)) |> Enum.join("\n")}</ol>"
      end

      def process_block(
            %{"type" => "ordered-list-item", "text" => text} = block,
            entity_map,
            context
          ) do
        "<li style=\"mso-special-format:numbullet;\">#{apply_ranges(block, entity_map, context)}</li>"
      end

      def process_block(
            %{"type" => "unordered-list-item", "text" => text} = block,
            entity_map,
            context
          ) do
        "<li style=\"mso-special-format:bullet;\">#{apply_ranges(block, entity_map, context)}</li>"
      end

      def header_tags do
        %{
          "one" => "h1",
          "two" => "h2",
          "three" => "h3",
          "four" => "h4",
          "five" => "h5",
          "six" => "h6"
        }
      end
    end
  end
end
