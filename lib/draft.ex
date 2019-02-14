defmodule Draft do
  defmacro __using__(_) do
    quote do
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

      use Draft.Block

      def to_html(input, context \\ []) do
        entity_map = Map.get(input, "entityMap")

        input
        |> Map.get("blocks")
        |> Enum.map(&(process_block(&1, entity_map, context)))
        |> Enum.join("")
      end
    end
  end
end
