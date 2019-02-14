defmodule DraftTest do
  use ExUnit.Case
  use Draft

  test "generate a <p>" do
    input = %{"entityMap"=>%{},"blocks"=>[%{"key"=>"9d21d","text"=>"Hello","type"=>"unstyled","depth"=>0,"inlineStyleRanges"=>[],"entityRanges"=>[],"data"=>%{}}]}
    output = "<p>Hello</p>"
    assert to_html(input) == output
  end

  test "generate a <h1>" do
    input = %{"entityMap"=>%{},"blocks"=>[%{"key"=>"9d21d","text"=>"Hello","type"=>"header-one","depth"=>0,"inlineStyleRanges"=>[],"entityRanges"=>[],"data"=>%{}}]}
    output = "<h1>Hello</h1>"
    assert to_html(input) == output
  end

  test "generate a <h2>" do
    input = %{"entityMap"=>%{},"blocks"=>[%{"key"=>"9d21d","text"=>"Hello","type"=>"header-two","depth"=>0,"inlineStyleRanges"=>[],"entityRanges"=>[],"data"=>%{}}]}
    output = "<h2>Hello</h2>"
    assert to_html(input) == output
  end

  test "generate a <h3>" do
    input = %{"entityMap"=>%{},"blocks"=>[%{"key"=>"9d21d","text"=>"Hello","type"=>"header-three","depth"=>0,"inlineStyleRanges"=>[],"entityRanges"=>[],"data"=>%{}}]}
    output = "<h3>Hello</h3>"
    assert to_html(input) == output
  end

  test "generate a <blockquote>" do
    input = %{"entityMap"=>%{},"blocks"=>[%{"key"=>"9d21d","text"=>"Hello","type"=>"blockquote","depth"=>0,"inlineStyleRanges"=>[],"entityRanges"=>[],"data"=>%{}}]}
    output = "<blockquote>Hello</blockquote>"
    assert to_html(input) == output
  end

  test "generate a <br>" do
    input = %{"entityMap"=>%{},"blocks"=>[%{"key"=>"9d21d","text"=>"","type"=>"unstyled","depth"=>0,"inlineStyleRanges"=>[],"entityRanges"=>[],"data"=>%{}}]}
    output = "<br>"
    assert to_html(input) == output
  end

  test "wraps single inline style" do
    input = %{"entityMap"=>%{},"blocks"=>[%{"text"=>"Hello","inlineStyleRanges"=>[%{"style"=>"BOLD","offset"=>2,"length"=>2}],"type"=>"unstyled","depth"=>0,"entityRanges"=>[],"data"=>%{},"key"=>"9d21d"}]}
    output = "<p>He<span style=\"font-weight: bold;\">ll</span>o</p>"
    assert to_html(input) == output
  end

  test "wraps multiple inline styles" do
    input = %{"entityMap"=>%{},"blocks"=>[%{"text"=>"Hello World!","inlineStyleRanges"=>[%{"style"=>"ITALIC","offset"=>8,"length"=>3},%{"style"=>"BOLD","offset"=>2,"length"=>2}],"type"=>"unstyled","depth"=>0,"entityRanges"=>[],"data"=>%{},"key"=>"9d21d"}]}
    output = "<p>He<span style=\"font-weight: bold;\">ll</span>o Wo<span style=\"font-style: italic;\">rld</span>!</p>"
    assert to_html(input) == output
  end

  test "wraps nested inline styles" do
    input = %{"entityMap"=>%{},"blocks"=>[%{"text"=>"Hello World!","inlineStyleRanges"=>[%{"style"=>"ITALIC","offset"=>2,"length"=>5},%{"style"=>"BOLD","offset"=>2,"length"=>2}],"type"=>"unstyled","depth"=>0,"entityRanges"=>[],"data"=>%{},"key"=>"9d21d"}]}
    output = "<p>He<span style=\"font-style: italic; font-weight: bold;\">ll</span><span style=\"font-style: italic;\">o W</span>orld!</p>"
    assert to_html(input) == output
  end

  test "wraps overlapping inline styles" do
    input = %{"entityMap"=>%{},"blocks"=>[%{"text"=>"Hello World!","inlineStyleRanges"=>[%{"style"=>"ITALIC","offset"=>2,"length"=>5}, %{"style"=>"BOLD","offset"=>4,"length"=>5}],"type"=>"unstyled","depth"=>0,"entityRanges"=>[],"data"=>%{},"key"=>"9d21d"}]}
    output = "<p>He<span style=\"font-style: italic;\">ll</span><span style=\"font-style: italic; font-weight: bold;\">o W</span><span style=\"font-weight: bold;\">or</span>ld!</p>"
    assert to_html(input) == output
  end

  test "wraps anchor entities" do
    input = %{"entityMap"=>%{0=>%{"type"=>"LINK","mutability"=>"MUTABLE","data"=>%{"url"=>"http://google.com"}}},
              "blocks"=>[%{"text"=>"Hello World!","inlineStyleRanges"=>[],"type"=>"unstyled","depth"=>0,"entityRanges"=>[
                            %{"offset"=>2,"length"=>3,"key"=>0}
                          ],"data"=>%{},"key"=>"9d21d"}]}
    output = "<p>He<a href=\"http://google.com\">llo</a> World!</p>"
    assert to_html(input) == output
  end

  test "wraps overlapping entities and inline styles" do
    input = %{"entityMap"=>%{0=>%{"type"=>"LINK","mutability"=>"MUTABLE","data"=>%{"url"=>"http://google.com"}}},
              "blocks"=>[%{"text"=>"Hello World!",
                           "inlineStyleRanges"=>[
                             %{"style"=>"ITALIC","offset"=>0,"length"=>4},
                             %{"style"=>"BOLD","offset"=>4,"length"=>4},
                           ],
                           "entityRanges"=>[
                             %{"offset"=>2,"length"=>3,"key"=>0}
                           ],
                           "type"=>"unstyled",
                           "depth"=>0,
                           "data"=>%{},"key"=>"9d21d"}]}
    output = "<p><span style=\"font-style: italic;\">He</span><a href=\"http://google.com\"><span style=\"font-style: italic;\">ll</span><span style=\"font-weight: bold;\">o</span></a><span style=\"font-weight: bold;\"> Wo</span>rld!</p>"
    assert to_html(input) == output
  end
end
