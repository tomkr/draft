defmodule Draft do
  @moduledoc """
  Provides functions for parsing DraftJS content.
  """

  @doc """
  Parses the given DraftJS input and returns the blocks as a list of
  maps.

  ## Examples
      iex> draft = ~s({"entityMap":{},"blocks":[{"key":"1","text":"Hello","type":"unstyled","depth":0,"inlineStyleRanges":[],"entityRanges":[],"data":{}}]})
      iex> Draft.blocks draft
      [%{"key" => "1", "text" => "Hello", "type" => "unstyled",
         "depth" => 0,  "inlineStyleRanges" => [], "entityRanges" => [],
         "data" => %{}}]
  """
  def blocks(input) do
    Poison.Parser.parse!(input)["blocks"]
  end

  @doc """
  Renders the given DraftJS input as html.

  ## Examples
      iex> draft = ~s({"entityMap":{},"blocks":[{"key":"1","text":"Hello","type":"unstyled","depth":0,"inlineStyleRanges":[],"entityRanges":[],"data":{}}]})
      iex> Draft.to_html draft
      "<p>Hello</p>"
  """
  def to_html(input) do
    input
      |> blocks
      |> Enum.map(&process_block/1)
      |> Enum.join("")
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
