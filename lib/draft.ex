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
        |> Enum.reduce([], &group_list_items/2)
        |> Enum.map(&(process_block(&1, entity_map, context)))
        |> Enum.join("")
      end

      @doc """
      Groups pertinent block types (i.e. ordered and unordered lists), allowing us to define
      `process_block` signatures for both the wrapper component and their children (see
      process_block signature for `unordered-list`, it's responsible for rendering its children)

      ## Examples
      iex> blocks = [%{"key"=>"1","text"=>"Hello","type"=>"unordered-list-item","depth"=>0,"inlineStyleRanges"=>[],"entityRanges"=>[],"data"=>%{}}]
      iex> Enum.reduce(blocks, [], group_list_items())
      [%{"type"=>"unordered-list","data"=>%{"children"=>[%{"key"=>"1","text"=>"Hello","type"=>"unordered-list-item","depth"=>0,"inlineStyleRanges"=>[],"entityRanges"=>[],"data"=>%{}}]}}]
      """

      defp group_list_items(block, acc) do
        case block["type"] do
          type when type in ["unordered-list-item", "ordered-list-item"] ->
            list_type = String.replace(block["type"], "-item", "")

            with {last_item, all_but_last_item} when not is_nil(last_item) <- List.pop_at(acc, length(acc) - 1),
                  type when type == list_type <- Map.get(last_item, "type")
                  #FIXME: this ignores depth
              do
                all_but_last_item ++ [add_block_item_to_previous_list(last_item, block)]
              else
                _ -> acc ++ [%{"type" => list_type,
                              "data" => %{"children" => [block]}}]
            end
          _ -> acc ++ [block]
        end
      end

      defp add_block_item_to_previous_list(previous_list, block) do
        updated_children = previous_list["data"]["children"] ++ [block]
        updated_data = Map.put(previous_list["data"], "children", updated_children)

        Map.put(previous_list, "data", updated_data)
      end
    end
  end
end
