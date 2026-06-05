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

  # A community solution
  # Much nicer.

  # def recite(strings) do
  #   strings
  #   |> Enum.chunk_every(2, 1, :discard)
  #   |> Enum.map_join("", fn [s1, s2] -> "For want of a #{s1} the #{s2} was lost.\n" end)
  #   |> Kernel.<>("And all for the want of a #{List.first(strings)}.\n")
  # end
end
