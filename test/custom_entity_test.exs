defmodule CustomEntityTest do
  use ExUnit.Case
  use Draft

  def process_entity(
    %{"type"=>"PERSONALIZATION",
      "mutability"=>"IMMUTABLE",
      "data"=>%{"value"=>value}}, _text, [contact: contact]) do
    contact |> Map.get(value)
  end

  test "nests entities that potentially replace content inside styles" do
    input = %{
      "blocks" => [%{
        "key" => "ck6bi",
        "data" => %{},
        "text" => "#CONTACT.NAME_FULL",
        "type" => "unstyled",
        "depth" => 0,
        "entityRanges" => [%{
          "key" => 0,
          "length" => 18,
          "offset" => 0
        }],
        "inlineStyleRanges" => [%{
          "style" => "BOLD",
          "length" => 18,
          "offset" => 0
        }]
      }],
      "entityMap" => %{
        "0" => %{
          "data" => %{
            "value" => "name"
          },
          "type" => "PERSONALIZATION",
          "mutability" => "IMMUTABLE"
        }
      }
    }

    assert to_html(input, contact: %{"name" => "Frodo", "email" => "frodo@middleearth.com"}) ==
      "<p><span style=\"font-weight: bold;\">Frodo</span></p>"
  end

  test "ranges adjacent to entities that potentially replace content" do
    input = %{
      "blocks" => [%{
        "key" => "ck6bi",
        "data" => %{},
        "text" => "It's going great #CONTACT.NAME_FULL. Right?",
        "type" => "unstyled",
        "depth" => 0,
        "entityRanges" => [%{
          "key" => 0,
          "length" => 5,
          "offset" => 5
        }, %{
          "key" => 1,
          "length" => 18,
          "offset" => 17
        }],
        "inlineStyleRanges" => [
          %{"style" => "BOLD",
            "length" => 5,
            "offset" => 37}]
      }],
      "entityMap" => %{
        "0" => %{
          "data" => %{
            "url" => "http://google.com"
          },
          "type" => "LINK",
          "mutability" => "MUTABLE"
        },
        "1" => %{
          "data" => %{
            "value" => "name"
          },
          "type" => "PERSONALIZATION",
          "mutability" => "IMMUTABLE"
        }
      }
    }

    assert to_html(input, contact: %{"name" => "Frodo", "email" => "frodo@middleearth.com"}) ==
      "<p>It's <a href=\"http://google.com\">going</a> great Frodo. <span style=\"font-weight: bold;\">Right</span>?</p>"
  end

  test "a random complex combination" do
    input = %{
      "blocks" => [%{
        "key" => "ck6bi",
        "data" => %{},
        "text" => "It's going great #CONTACT.NAME_FULL. Right?",
        "type" => "unstyled",
        "depth" => 0,
        "entityRanges" => [%{
          "key" => 0,
          "length" => 38,
          "offset" => 5
        }, %{
          "key" => 1,
          "length" => 18,
          "offset" => 17
        }],
        "inlineStyleRanges" => [%{
          "style" => "BOLD",
          "length" => 1,
          "offset" => 0
        }, %{
          "style" => "BOLD",
          "length" => 26,
          "offset" => 11
        }]
      }],
      "entityMap" => %{
        "0" => %{
          "data" => %{
            "url" => "http://google.com"
          },
          "type" => "LINK",
          "mutability" => "MUTABLE"
        },
        "1" => %{
          "data" => %{
            "value" => "name"
          },
          "type" => "PERSONALIZATION",
          "mutability" => "IMMUTABLE"
        }
      }
    }

    assert to_html(input, contact: %{"name" => "Frodo", "email" => "frodo@middleearth.com"}) ==
      "<p><span style=\"font-weight: bold;\">I</span>t's <a href=\"http://google.com\">going <span style=\"font-weight: bold;\">great </span><span style=\"font-weight: bold;\">Frodo</span><span style=\"font-weight: bold;\">. </span>Right?</a></p>"
  end
end
