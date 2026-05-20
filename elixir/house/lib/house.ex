defmodule House do
  @doc """
  Return verses of the nursery rhyme 'This is the House that Jack Built'.
  """

  @lyrics [
    {"the house that Jack built", ""},
    {"the malt", "lay in"},
    {"the rat", "ate the"},
    {"the cat", "killed the"},
    {"the dog", "worried the"},
    {"the cow with the crumpled horn", "tossed the"},
    {"the maiden all forlorn", "milked the"},
    {"the man all tattered and torn", "kissed the"},
    {"the priest all shaven and shorn", "married the"},
    {"the rooster that crowed in the morn", "woke the"},
    {"the farmer sowing his corn", "kept the"},
    {"the horse and the hound and the horn", "belonged to"}
  ]

  def recite(start, stop) do
    Enum.map(start..stop, &build_verse/1)
    |> Enum.join("\n")
    |> then(fn phrase -> phrase <> "\n" end)
  end

  defp build_verse(n) do
    subjects = Enum.take(@lyrics, n) |> Enum.reverse()

    [{head_noun, _} | rest] = subjects

    first_line = "This is #{head_noun}"

    connector_lines =
      rest
      |> Enum.map(fn
        {noun, ""} -> "that lay in #{noun}"
        {noun, verb} -> "that #{verb} #{noun}"
      end)

    [first_line | connector_lines] |> Enum.join("\n")
  end
end
