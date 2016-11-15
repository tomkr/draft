defmodule Draft do
  def to_html(input) do
    Poison.Parser.parse!(input)["blocks"]
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
