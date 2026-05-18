defmodule Say do
  @doc """
  Translate a positive integer into English.
  """
  @rosetta %{
    1 => "one",
    2 => "two",
    3 => "three",
    4 => "four",
    5 => "five",
    6 => "six",
    7 => "seven",
    8 => "eight",
    9 => "nine",
    10 => "ten",
    11 => "eleven",
    12 => "twelve",
    13 => "thirteen",
    14 => "fourteen",
    15 => "fifteen",
    16 => "sixteen",
    17 => "seventeen",
    18 => "eighteen",
    19 => "nineteen",
    20 => "twenty",
    30 => "thirty",
    40 => "forty",
    50 => "fifty",
    60 => "sixty",
    70 => "seventy",
    80 => "eighty",
    90 => "ninety"
  }

  @scale [
    {1_000_000_000, "billion"},
    {1_000_000, "million"},
    {1_000, "thousand"},
    {100, "hundred"}
  ]

  def in_english(number) when number < 0 or number > 999_999_999_999,
    do: {:error, "number is out of range"}

  def in_english(0), do: {:ok, "zero"}
  def in_english(number), do: {:ok, spell(number)}

  defp spell(n) when is_map_key(@rosetta, n), do: @rosetta[n]

  # 21..99 (excluding the round tens already in @rosetta): join tens and ones with a hyphen.
  defp spell(n) when n < 100 do
    "#{@rosetta[div(n, 10) * 10]}-#{@rosetta[rem(n, 10)]}"
  end

  defp spell(n) do
    {factor, label} = Enum.find(@scale, fn {factor, _} -> n >= factor end)
    head = "#{spell(div(n, factor))} #{label}"

    case rem(n, factor) do
      0 -> head
      rest -> "#{head} #{spell(rest)}"
    end
  end
end
