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
