defmodule Draft.Block do
  defmacro __using__(_) do
    quote do
      @moduledoc """
      Converts a single DraftJS block to html.
      """

      use Draft.Ranges

      def process_block(%{"type" => "unstyled",
                          "text" => "",
                          "key" => _,
                          "data" => _,
                          "depth" => _,
                          "entityRanges" => _,
                          "inlineStyleRanges" => _}, _, _) do
        "<br>"
      end

      def process_block(%{"type" => "header-" <> header,
                          "text" => text,
                          "key" => _,
                          "data" => _,
                          "depth" => _,
                          "entityRanges" => entity_ranges,
                          "inlineStyleRanges" => inline_style_ranges},
                        entity_map, context) do
        tag = header_tags[header]
        "<#{tag}>#{apply_ranges(text, inline_style_ranges, entity_ranges, entity_map, context)}</#{tag}>"
      end

      def process_block(%{"type" => "blockquote",
                          "text" => text,
                          "key" => _,
                          "data" => _,
                          "depth" => _,
                          "entityRanges" => entity_ranges,
                          "inlineStyleRanges" => inline_style_ranges},
                        entity_map, context) do
        "<blockquote>#{apply_ranges(text, inline_style_ranges, entity_ranges, entity_map, context)}</blockquote>"
      end

      def process_block(%{"type" => "unstyled",
                          "text" => text,
                          "key" => _,
                          "data" => _,
                          "depth" => _,
                          "entityRanges" => entity_ranges,
                          "inlineStyleRanges" => inline_style_ranges},
                        entity_map, context) do
        "<p>#{apply_ranges(text, inline_style_ranges, entity_ranges, entity_map, context)}</p>"
      end

      def process_block(%{"type" => "unordered-list",
                          "data" => %{"children" => children}},
        entity_map, context) do
        "<ul>#{Enum.map(children, &(process_block(&1, entity_map, context))) |> Enum.join("")}</ul>"
      end

      def process_block(%{"type" => "ordered-list",
                          "data" => %{"children" => children}},
        entity_map, context) do
        "<ol>#{Enum.map(children, &(process_block(&1, entity_map, context))) |> Enum.join("")}</ol>"
      end

      def process_block(%{"type" => "ordered-list-item",
                          "text" => text,
                          "key" => _,
                          "data" => _,
                          "depth" => _,
                          "entityRanges" => entity_ranges,
                          "inlineStyleRanges" => inline_style_ranges},
        entity_map, context) do
        "<li>#{apply_ranges(text, inline_style_ranges, entity_ranges, entity_map, context)}</li>"
      end

      def process_block(%{"type" => "unordered-list-item",
                          "text" => text,
                          "key" => _,
                          "data" => _,
                          "depth" => _,
                          "entityRanges" => entity_ranges,
                          "inlineStyleRanges" => inline_style_ranges},
        entity_map, context) do
        "<li>#{apply_ranges(text, inline_style_ranges, entity_ranges, entity_map, context)}</li>"
      end

      def header_tags do
        %{
          "one"   => "h1",
          "two"   => "h2",
          "three" => "h3"
        }
      end
    end
  end
end
