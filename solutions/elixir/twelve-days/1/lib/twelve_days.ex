defmodule TwelveDays do
  @doc """
  Given a `number`, return the song's verse for that specific day, including
  all gifts for previous days in the same line.
  """
  @parts [
    {"first", "a Partridge in a Pear Tree"},
    {"second", "two Turtle Doves"},
    {"third", "three French Hens"},
    {"fourth", "four Calling Birds"},
    {"fifth", "five Gold Rings"},
    {"sixth", "six Geese-a-Laying"},
    {"seventh", "seven Swans-a-Swimming"},
    {"eighth", "eight Maids-a-Milking"},
    {"ninth", "nine Ladies Dancing"},
    {"tenth", "ten Lords-a-Leaping"},
    {"eleventh", "eleven Pipers Piping"},
    {"twelfth", "twelve Drummers Drumming"}
  ]

  @spec verse(number :: integer) :: String.t()

  def verse(1),
    do: "On the first day of Christmas my true love gave to me: a Partridge in a Pear Tree."

  def verse(number) when number >= 1 and number <= 12 do
    # index is one less than number
    number = number - 1

    # get the day, we don't need the thing here
    {day, _} = @parts |> Enum.at(number)

    # and now the verse
    "On the #{day} day of Christmas my true love gave to me: " <> parts("", number)
  end

  defp parts(gifts, 0), do: gifts <> "and a Partridge in a Pear Tree."

  defp parts(gifts, number) do
    # get the thing
    {_, thing} =
      @parts
      |> Enum.at(number)

    # now recurse
    parts(gifts <> "#{thing}, ", number - 1)
  end

  @doc """
  Given a `starting_verse` and an `ending_verse`, return the verses for each
  included day, one per line.
  """
  @spec verses(starting_verse :: integer, ending_verse :: integer) :: String.t()
  def verses(starting_verse, ending_verse) do
    starting_verse..ending_verse
    |> Enum.map_join("\n", fn number ->
      verse(number)
    end)
  end

  @doc """
  Sing all 12 verses, in order, one verse per line.
  """
  @spec sing() :: String.t()
  def sing, do: verses(1, 12)
end
