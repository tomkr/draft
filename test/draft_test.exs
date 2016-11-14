defmodule DraftTest do
  use ExUnit.Case
  doctest Draft

  test "generate a <p>" do
    input = ~s({"entityMap":{},"blocks":[{"key":"9d21d","text":"Hello","type":"unstyled","depth":0,"inlineStyleRanges":[],"entityRanges":[],"data":{}}]})
    output = "<p>Hello</p>"
    assert Draft.to_html(input) == output
  end
end
