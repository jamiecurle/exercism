defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

      iex> Markdown.parse("This is a paragraph")
      "<p>This is a paragraph</p>"

      iex> Markdown.parse("# Header!\\n* __Bold Item__\\n* _Italic Item_")
      "<h1>Header!</h1><ul><li><strong>Bold Item</strong></li><li><em>Italic Item</em></li></ul>"
  """
  @spec tokenise(String.t()) :: list()
  def tokenise(markdown) do
    markdown
    |> to_lines()
    |> block_elements()
    |> group_blocks()
    |> inline_elements()
  end

  def to_lines(markdown), do: String.split(markdown, "\n")

  @spec block_elements(list()) :: list()
  def block_elements(markdown_list) do
    Enum.map(markdown_list, &match_block_element/1)
  end

  @spec group_blocks(list()) :: list()
  def group_blocks(ungrouped) do
    ungrouped
    |> Enum.chunk_by(fn {tag, _} -> tag end)
    |> Enum.map(fn [{tag, _} | _] = chunk ->
      {tag, Enum.flat_map(chunk, fn {_, content} -> content end)}
    end)
  end

  # this comes in as a list
  @spec inline_elements(list()) :: list()
  def inline_elements(grouped) do
    IO.inspect(grouped, label: "grouped")
  end

  # content comes in as a list and leaves as a list
  # but in order to parse, we need to split into another list
  @spec italic(list(), list()) :: list()
  def italic(content) when is_list(content), do: italic(content, [])
  def italic([], result), do: result

  def italic([head | tail], result) do
    IO.inspect(head, label: "head")
    IO.inspect(tail, label: "tail")
    IO.inspect(result, label: "result")

    parsed =
      case head do
        {tag, content} -> {tag, match_italic(content)}
        content -> match_italic(content)
      end

    italic(tail, result ++ [parsed])
  end

  # you were here

  def match_italic(content) do
    Regex.split(~r/_(.+?)_/, content, include_captures: true)
    |> Enum.map(fn
      "__" <> inner -> {:i, [String.trim_trailing(inner, "_")]}
      part -> part
    end)
  end

  @spec bold(list(), list()) :: list()
  # this is just syntactic sugar so it can be called without the empty list
  def bold(content) when is_list(content), do: bold(content, [])

  # the base case
  def bold([], result), do: result

  def bold([head | tail], result) do
    parsed =
      case head do
        {tag, content} -> {tag, match_bold(content)}
        content -> match_bold(content)
      end

    bold(tail, result ++ [parsed])
  end

  # the one that does the lifting
  def match_bold(content) do
    Regex.split(~r/__(.+?)__/, content, include_captures: true)
    |> Enum.map(fn
      "__" <> inner -> {:b, [String.trim_trailing(inner, "__")]}
      part -> part
    end)
  end

  # def inline_elements(grouped) do
  #   grouped
  #   |> Enum.map(fn {_tag, contents} ->
  #     do_parse_inline(contents)
  #   end)
  # end

  # def do_parse_inline(contents) do
  #   contents
  #   |> bold()
  #   |> italic()

  #   # IO.inspect(contents)
  # end

  # def bold(content) do
  #   Regex.split(~r/__(.+?)__/, content, include_captures: true)
  #   |> Enum.map(fn
  #     "__" <> inner -> {:b, String.trim_trailing(inner, "__")}
  #     part -> part
  #   end)
  # end

  # def italic(content) do
  #   Regex.split(~r/_(.+?)_/, content, include_captures: true)
  #   |> Enum.map(fn
  #     "__" <> inner -> {:i, String.trim_trailing(inner, "_")}
  #     part -> part
  #   end)
  # end

  # @doc """
  # Groups similar elements together
  # """
  # def group_elements(elem), do: group_elements(elem, [])

  # def group_elements({tag, _contents}, [{previous_tag, contents} | rest] = acc) do
  #   IO.inspect({tag, previous_tag})
  #   {tag, acc}

  #   if tag == previous_tag do
  #     IO.inspect(previous_tag)
  #   else
  #     {[{tag, contents} | acc]}
  #   end
  # end

  @doc """
  Finds block level html elements at the start of a newline and converts into
  a data structure suitable for working with
  """
  @spec match_block_element(String.t()) :: {atom(), [String.t()]}
  def match_block_element("# " <> content), do: {:h1, [content]}
  def match_block_element("## " <> content), do: {:h2, [content]}
  def match_block_element("### " <> content), do: {:h3, [content]}
  def match_block_element("#### " <> content), do: {:h4, [content]}
  def match_block_element("##### " <> content), do: {:h5, [content]}
  def match_block_element("###### " <> content), do: {:h6, [content]}
  def match_block_element("* " <> content), do: {:li, [content]}
  def match_block_element(content), do: {:p, [content]}

  @spec parse(String.t()) :: String.t()
  def parse(m) do
    patch(Enum.join(Enum.map(String.split(m, "\n"), fn t -> process(t) end)))
  end

  defp process(t) do
    if (String.starts_with?(t, "#") && !String.starts_with?(t, "#######")) ||
         String.starts_with?(t, "*") do
      if String.starts_with?(t, "#") do
        enclose_with_header_tag(parse_header_md_level(t))
      else
        parse_list_md_level(t)
      end
    else
      enclose_with_paragraph_tag(String.split(t))
    end
  end

  defp parse_header_md_level(hwt) do
    [h | t] = String.split(hwt)
    {to_string(String.length(h)), Enum.join(t, " ")}
  end

  defp parse_list_md_level(l) do
    t = String.split(String.trim_leading(l, "* "))
    "<li>" <> join_words_with_tags(t) <> "</li>"
  end

  defp enclose_with_header_tag({hl, htl}) do
    "<h" <> hl <> ">" <> htl <> "</h" <> hl <> ">"
  end

  defp enclose_with_paragraph_tag(t) do
    "<p>#{join_words_with_tags(t)}</p>"
  end

  defp join_words_with_tags(t) do
    Enum.join(Enum.map(t, fn w -> replace_md_with_tag(w) end), " ")
  end

  defp replace_md_with_tag(w) do
    replace_suffix_md(replace_prefix_md(w))
  end

  defp replace_prefix_md(w) do
    cond do
      w =~ ~r/^#{"__"}{1}/ -> String.replace(w, ~r/^#{"__"}{1}/, "<strong>", global: false)
      w =~ ~r/^[#{"_"}{1}][^#{"_"}+]/ -> String.replace(w, ~r/_/, "<em>", global: false)
      true -> w
    end
  end

  defp replace_suffix_md(w) do
    cond do
      w =~ ~r/#{"__"}{1}$/ -> String.replace(w, ~r/#{"__"}{1}$/, "</strong>")
      w =~ ~r/[^#{"_"}{1}]/ -> String.replace(w, ~r/_/, "</em>")
      true -> w
    end
  end

  defp patch(l) do
    String.replace(l, "<li>", "<ul>" <> "<li>", global: false)
    |> String.reverse()
    |> String.replace(String.reverse("</li>"), String.reverse("</li></ul>"), global: false)
    |> String.reverse()
  end
end
