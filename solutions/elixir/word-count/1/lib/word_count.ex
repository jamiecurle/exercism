defmodule WordCount do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    sentence
    |> String.split(~r/[^\w']|_|'(?!\w)|(?<!\w)'/, trim: true)
    |> Enum.map(&String.downcase/1)
    |> Enum.frequencies()
  end
end
