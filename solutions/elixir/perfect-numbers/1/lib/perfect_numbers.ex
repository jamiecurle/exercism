defmodule PerfectNumbers do
  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: {:ok, atom} | {:error, String.t()}
  def classify(1), do: {:ok, :deficient}

  def classify(number) when number > 0 do
    1..floor(:math.sqrt(number))
    |> Enum.reduce([], &factors(&1, &2, number))
    |> Enum.sum()
    |> then(fn sum ->
      cond do
        sum == number -> {:ok, :perfect}
        sum > number -> {:ok, :abundant}
        sum < number -> {:ok, :deficient}
      end
    end)
  end

  def classify(_), do: {:error, "Classification is only possible for natural numbers."}

  defp factors(1, acc, _number), do: [1 | acc]

  defp factors(i, acc, number) do
    cond do
      rem(number, i) == 0 && i == div(number, i) -> [i | acc]
      rem(number, i) == 0 -> [i, div(number, i) | acc]
      true -> acc
    end
  end
end
