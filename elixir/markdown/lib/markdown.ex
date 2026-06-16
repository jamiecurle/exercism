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
    |> Enum.map_join(&process/1)
    |> patch_ul()
  end

  defp process("* " <> text), do: "<li>" <> inline_tags(text) <> "</li>"
  defp process("# " <> text), do: "<h1>#{text}</h1>"
  defp process("## " <> text), do: "<h2>#{text}</h2>"
  defp process("### " <> text), do: "<h3>#{text}</h3>"
  defp process("#### " <> text), do: "<h4>#{text}</h4>"
  defp process("##### " <> text), do: "<h5>#{text}</h5>"
  defp process("###### " <> text), do: "<h6>#{text}</h6>"
  defp process(text), do: "<p>" <> inline_tags(text) <> "</p>"

  defp inline_tags(text) do
    text
    |> String.replace(~r/__(.+?)__/, "<strong>\\1</strong>")
    |> String.replace(~r/_(.+?)_/, "<em>\\1</em>")
  end

  defp patch_ul(html) do
    String.replace(html, "<li>", "<ul><li>", global: false)
    |> String.reverse()
    |> String.replace(String.reverse("</li>"), String.reverse("</li></ul>"), global: false)
    |> String.reverse()
  end
end
