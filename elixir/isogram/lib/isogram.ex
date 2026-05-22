defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t() | list) :: boolean
  def isogram?(sentence) when is_binary(sentence) do
    sentence
    |> String.downcase()
    |> String.replace(~r/[^a-z]/, "")
    |> String.graphemes()
    |> isogram?()
  end

  def isogram?([] = graphemes) when is_list(graphemes), do: true

  def isogram?(graphemes) when is_list(graphemes) do
    graphemes
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.all?(&(&1 <= 1))
  end

  def isogram?(_), do: false
end
