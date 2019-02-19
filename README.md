# Draft

Draft is a module that parses a JSON representation of [Draft.js](https://facebook.github.io/draft-js/) `convertToRaw` output and turns it into HTML.

## Usage

You can `use Draft` in your module, and then extend it with custom 
`process_block`, `process_style`, and `process_entity` function signatures

```
  # define your draft module
  defmodule MyCustomDraft do
    use Draft


    def process_block(%{"type" => "atomic",
                        "text" => "",
                        "key" => _,
                        "data" => %{"type" => "image", "url" => url},
                        "depth" => _,
                        "entityRanges" => _,
                        "inlineStyleRanges" => _}, _) do
      "<img src='#{url}' />"
    end
  end

  # somewhere else you can pass your custom draft map to `to_html`
  input = %{
    "entityMap"=>%{},
    "blocks"=>[
      %{"key"=>"9d21d",
        "text"=>"Hello",
        "type"=>"header-one",
        "depth"=>0,
        "inlineStyleRanges"=>[],
        "entityRanges"=>[],
        "data"=>%{}}
      %{"key"=>"d12d9",
        "text"=>"",
        "type"=>"atomic",
        "depth"=>0,
        "inlineStyleRanges"=>[],
        "entityRanges"=>[],
        "data"=>%{
          "type"=>"atomic",
          "url"=>"https://uploads.digitalonboarding.com/do_logo_long.png"}}]}

  MyCustomDraft.to_html(input)
```

You can pass a third variable for context that your custom processors can hook 
into.

```
  # capture the relevant context vars in your custom processors
  defmodule MyCustomDraft do
    use Draft


    def process_block(%{"type" => "atomic",
                        "text" => "",
                        "key" => _,
                        "data" => %{"type" => "image", "url" => url},
                        "depth" => _,
                        "entityRanges" => _,
                        "inlineStyleRanges" => _}, [user: user]) do
      "<img src='#{url}' alt='#{user.name}' />"
    end
  end

  # somewhere else you can pass any number of vars as the third argument

  user = %{name: "Pablo"}

  input = %{
    "entityMap"=>%{},
    "blocks"=>[
      %{"key"=>"9d21d",
        "text"=>"Hello",
        "type"=>"header-one",
        "depth"=>0,
        "inlineStyleRanges"=>[],
        "entityRanges"=>[],
        "data"=>%{}}
      %{"key"=>"d12d9",
        "text"=>"",
        "type"=>"atomic",
        "depth"=>0,
        "inlineStyleRanges"=>[],
        "entityRanges"=>[],
        "data"=>%{
          "type"=>"atomic",
          "url"=>"https://uploads.digitalonboarding.com/do_logo_long.png"}}]}

  MyCustomDraft.to_html(input, user: user)
```
