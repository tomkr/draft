defmodule TreeTest do
  use ExUnit.Case

  test "builds a tree" do
    assert DraftTree.build_tree(
             [
               %{"length" => 1, "offset" => 0, "styles" => ["BOLD"]},
               %{"key" => 0, "length" => 38, "offset" => 5},
               %{"length" => 6, "offset" => 11, "styles" => ["BOLD"]},
               %{"length" => 18, "offset" => 17, "styles" => ["BOLD"]},
               %{"key" => 1, "length" => 18, "offset" => 17},
               %{"length" => 2, "offset" => 35, "styles" => ["BOLD"]}
             ],
             "It's going great #CONTACT.NAME_FULL. Right?"
           ) ==
             %DraftTree.Node{
               key: nil,
               length: 43,
               offset: 0,
               styles: nil,
               text: "It's going great #CONTACT.NAME_FULL. Right?",
               children: [
                 %DraftTree.Node{
                   key: nil,
                   length: 1,
                   offset: 0,
                   styles: ["BOLD"],
                   text: "I",
                   children: []
                 },
                 %DraftTree.Node{
                   key: 0,
                   length: 38,
                   offset: 5,
                   styles: nil,
                   text: "going great #CONTACT.NAME_FULL. Right?",
                   children: [
                     %DraftTree.Node{
                       key: nil,
                       length: 6,
                       offset: 11,
                       styles: ["BOLD"],
                       text: "great ",
                       children: []
                     },
                     %DraftTree.Node{
                       key: nil,
                       length: 18,
                       offset: 17,
                       styles: ["BOLD"],
                       text: "#CONTACT.NAME_FULL",
                       children: [
                         %DraftTree.Node{
                           key: 1,
                           length: 18,
                           offset: 17,
                           styles: nil,
                           text: "#CONTACT.NAME_FULL",
                           children: []
                         }
                       ]
                     },
                     %DraftTree.Node{
                       key: nil,
                       length: 2,
                       offset: 35,
                       styles: ["BOLD"],
                       text: ". ",
                       children: []
                     }
                   ]
                 }
               ]
             }
  end
end
