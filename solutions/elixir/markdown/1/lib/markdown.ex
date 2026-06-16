defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

      iex> Markdown.parse("This is a paragraph")
      "<p>This is a paragraph</p>"

      iex> Markdown.parse("# Header!\\n* __Bold Item__\\n* _Italic Item_")
      "<h1>Header!</h1><ul><li><strong>Bold Item</strong></li><li><em>Italic Item</em></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(markdown) do
    String.split(markdown, "\n")
    |> Enum.map(fn t -> process(t) end)
    |> Enum.join()
    |> patch()
  end

  defp process("*" <> text), do: "<li>" <> join_words_with_tags(text) <> "</li>"
  defp process("# " <> text), do: "<h1>#{text}</h1>"
  defp process("## " <> text), do: "<h2>#{text}</h2>"
  defp process("### " <> text), do: "<h3>#{text}</h3>"
  defp process("#### " <> text), do: "<h4>#{text}</h4>"
  defp process("##### " <> text), do: "<h5>#{text}</h5>"
  defp process("###### " <> text), do: "<h6>#{text}</h6>"
  defp process(text), do: "<p>" <> join_words_with_tags(text) <> "</p>"

  defp join_words_with_tags(text) do
    text
    |> String.split()
    |> Enum.map_join(" ", fn word -> replace_md_with_tag(word) end)
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
