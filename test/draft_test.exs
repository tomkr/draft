defmodule DraftTest do
  use ExUnit.Case
  doctest Draft

  test "generate a <p>" do
    input = ~s({"entityMap":{},"blocks":[{"key":"9d21d","text":"Hello","type":"unstyled","depth":0,"inlineStyleRanges":[],"entityRanges":[],"data":{}}]})
    output = "<p>Hello</p>"
    assert Draft.to_html(input) == output
  end

  test "generate a <h1>" do
    input = ~s({"entityMap":{},"blocks":[{"key":"9d21d","text":"Hello","type":"header-one","depth":0,"inlineStyleRanges":[],"entityRanges":[],"data":{}}]})
    output = "<h1>Hello</h1>"
    assert Draft.to_html(input) == output
  end

  test "generate a <br>" do
    input = ~s({"entityMap":{},"blocks":[{"key":"9d21d","text":"","type":"unstyled","depth":0,"inlineStyleRanges":[],"entityRanges":[],"data":{}}]})
    output = "<br>"
    assert Draft.to_html(input) == output
  end
end
