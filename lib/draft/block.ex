defmodule Draft.Block do
  @moduledoc """
  Converts a single DraftJS block to html.
  """

  @doc """
  Renders the given DraftJS input as html.

  ## Examples
      iex> block = %{"key" => "1", "text" => "Hello", "type" => "unstyled",
      ...>   "depth" => 0,  "inlineStyleRanges" => [], "entityRanges" => [],
      ...>   "data" => %{}}
      iex> Draft.Block.to_html block
      "<p>Hello</p>"
  """
  def to_html(block) do
    process_block(block)
  end

  defp process_block(%{"type" => "unstyled",
                      "text" => "",
                      "key" => _,
                      "data" => _,
                      "depth" => _,
                      "entityRanges" => _,
                      "inlineStyleRanges" => _}) do
    "<br>"
  end

  defp process_block(%{"type" => "header-" <> header,
                      "text" => text,
                      "key" => _,
                      "data" => _,
                      "depth" => _,
                      "entityRanges" => _,
                      "inlineStyleRanges" => _}) do
    tag = header_tags[header]
    "<#{tag}>#{text}</#{tag}>"
  end

  defp process_block(%{"type" => "blockquote",
                      "text" => text,
                      "key" => _,
                      "data" => _,
                      "depth" => _,
                      "entityRanges" => _,
                      "inlineStyleRanges" => _}) do
    "<blockquote>#{text}</blockquote>"
  end

  defp process_block(%{"type" => "unstyled",
                      "text" => text,
                      "key" => _,
                      "data" => _,
                      "depth" => _,
                      "entityRanges" => _,
                      "inlineStyleRanges" => _}) do
    "<p>#{text}</p>"
  end

  defp header_tags do
    %{
      "one"   => "h1",
      "two"   => "h2",
      "three" => "h3"
    }
  end
end
