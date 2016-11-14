defmodule Draft do
  def to_html(input) do
    blocks = Poison.Parser.parse!(input)["blocks"]
    Enum.map(blocks, &process_block/1)
      |> Enum.join("")
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
end
