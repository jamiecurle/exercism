defmodule House do
  @doc """
  Return verses of the nursery rhyme 'This is the House that Jack Built'.
  """

  @lyrics [
    {"house", "Jack built"},
    {"malt", "lay in"},
    {"rat", "ate"},
    {"cat", "killed"},
    {"dog", "worried"},
    {"cow with the crumpled horn", "tossed"},
    {"maiden all forlorn", "milked"},
    {"man all tattered and torn", "kissed"},
    {"priest all shaven and shorn", "married"},
    {"rooster that crowed in the morn", "woke"},
    {"farmer sowing his corn", "kept"},
    {"horse and the hound and the horn", "belonged to"}
  ]

  def recite(start, stop) do
    Enum.map(start..stop, &build_verse/1)
    |> Enum.join("\n")
    |> then(fn phrase -> phrase <> "\n" end)
  end

  defp build_verse(n) do
    # get the lyrics we need
    lyrics =
      @lyrics
      |> Enum.take(n)
      |> Enum.reverse()

    # get the last line off the lyrics (not first - reversed)
    [{noun, verb} | rest] = lyrics

    # process the lyrics
    verse =
      rest
      |> Enum.map(fn {noun, verb} ->
        "the #{noun} that #{verb}"
      end)

    # build it all up
    ["This is the #{noun} that #{verb}" | verse]
    |> Enum.join(" ")
    |> then(fn phrase -> phrase <> "." end)
  end
end
