defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t()) :: boolean
  def isogram?(sentence) do
    sentence
    |> String.downcase()
    |> String.replace(~r/[^a-z]/, "")
    |> String.graphemes()
    |> is_isogram?()
  end

  defp is_isogram?([]), do: true

  defp is_isogram?(graphemes) do
    graphemes
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.all?(&(&1 <= 1))
  end
end
