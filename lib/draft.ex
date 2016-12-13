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
      |> Enum.map(&Draft.Block.to_html/1)
      |> Enum.join("")
  end
end
