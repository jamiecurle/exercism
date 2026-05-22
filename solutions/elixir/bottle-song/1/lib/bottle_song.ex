defmodule BottleSong do
  @moduledoc """
  Handles lyrics of the popular children song: Ten Green Bottles

  Note: UK version, or at least the North East of England version
  is ...bottles STANDING... on the wall because a bottle cannot hang without
  some form of fastner which the rhym totally fails to mention.

  Picky man is picky.
  """
  @words %{
    0 => "no",
    1 => "one",
    2 => "two",
    3 => "three",
    4 => "four",
    5 => "five",
    6 => "six",
    7 => "seven",
    8 => "eight",
    9 => "nine",
    10 => "ten"
  }

  @spec recite(pos_integer, pos_integer) :: String.t()
  def recite(start_bottle, verses) do
    1..verses
    |> Enum.map_join("\n\n", &verse_template(&1, start_bottle))
  end

  defp verse_template(verse, bottle) do
    # figure out the words
    wall = Map.get(@words, bottle - verse + 1)
    fall = Map.get(@words, bottle - verse)

    # now return the verse
    """
    #{wall |> String.capitalize()} green #{pluralise_bottle(wall)} hanging on the wall,
    #{wall |> String.capitalize()} green #{pluralise_bottle(wall)} hanging on the wall,
    And if one green bottle should accidentally fall,
    There'll be #{fall} green #{pluralise_bottle(fall)} hanging on the wall.\
    """
  end

  defp pluralise_bottle("one"), do: "bottle"
  defp pluralise_bottle(_), do: "bottles"
end
