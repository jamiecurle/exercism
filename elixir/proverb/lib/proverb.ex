defmodule Proverb do
  @doc """
  Generate a proverb from a list of strings.
  """
  @spec recite(strings :: [String.t()]) :: String.t()
  def recite([]), do: ""

  def recite([final | _] = strings) do
    strings
    |> do_recite(final, "")
  end

  defp do_recite([_], final, verse) do
    verse <> "And all for the want of a #{final}.\n"
  end

  defp do_recite([_ | tail] = prose, final, verse) do
    [want | lost] = Enum.take(prose, 2)
    do_recite(tail, final, verse <> "For want of a #{want} the #{lost} was lost.\n")
  end
end
