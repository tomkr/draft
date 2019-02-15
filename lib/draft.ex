defmodule Draft do
  @moduledoc """
  Provides functions for parsing DraftJS content.
  """

  @doc """
  Renders the given DraftJS input as html.

  ## Examples
      iex> draft = %{"entityMap"=>%{},"blocks"=>[%{"key"=>"1","text"=>"Hello","type"=>"unstyled","depth"=>0,"inlineStyleRanges"=>[],"entityRanges"=>[],"data"=>%{}}]}
      iex> Draft.to_html draft
      "<p>Hello</p>"
  """
  def to_html(input) do
    entity_map = Map.get(input, "entityMap")

    input
      |> Map.get("blocks")
      |> Enum.map(&(Draft.Block.to_html(&1, entity_map)))
      |> Enum.join("")
  end
end
