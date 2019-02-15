defmodule Draft.Block do
  @moduledoc """
  Converts a single DraftJS block to html.
  """

  alias Draft.Ranges

  @doc """
  Renders the given DraftJS input as html.

  ## Examples
      iex> entity_map = %{}
      iex> block = %{"key" => "1", "text" => "Hello", "type" => "unstyled",
      ...>   "depth" => 0,  "inlineStyleRanges" => [], "entityRanges" => [],
      ...>   "data" => %{}}
      iex> Draft.Block.to_html block, entity_map
      "<p>Hello</p>"
  """
  def to_html(block, entity_map) do
    process_block(block, entity_map)
  end

  defp process_block(%{"type" => "unstyled",
                      "text" => "",
                      "key" => _,
                      "data" => _,
                      "depth" => _,
                      "entityRanges" => _,
                      "inlineStyleRanges" => _}, _) do
    "<br>"
  end

  defp process_block(%{"type" => "header-" <> header,
                      "text" => text,
                      "key" => _,
                      "data" => _,
                      "depth" => _,
                      "entityRanges" => entity_ranges,
                      "inlineStyleRanges" => inline_style_ranges},
                     entity_map) do
    tag = header_tags[header]
    "<#{tag}>#{Ranges.apply(text, inline_style_ranges, entity_ranges, entity_map)}</#{tag}>"
  end

  defp process_block(%{"type" => "blockquote",
                      "text" => text,
                      "key" => _,
                      "data" => _,
                      "depth" => _,
                      "entityRanges" => entity_ranges,
                      "inlineStyleRanges" => inline_style_ranges},
                     entity_map) do
    "<blockquote>#{Ranges.apply(text, inline_style_ranges, entity_ranges, entity_map)}</blockquote>"
  end

  defp process_block(%{"type" => "unstyled",
                      "text" => text,
                      "key" => _,
                      "data" => _,
                      "depth" => _,
                      "entityRanges" => entity_ranges,
                      "inlineStyleRanges" => inline_style_ranges},
                     entity_map) do
    "<p>#{Ranges.apply(text, inline_style_ranges, entity_ranges, entity_map)}</p>"
  end

  defp header_tags do
    %{
      "one"   => "h1",
      "two"   => "h2",
      "three" => "h3"
    }
  end
end
