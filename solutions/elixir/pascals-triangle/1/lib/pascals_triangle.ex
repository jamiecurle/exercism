defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(num) do
    Stream.iterate([1], fn prev ->
      [0 | prev]
      |> Enum.zip(prev ++ [0])
      |> Enum.map(fn {a, b} -> a + b end)
    end)
    |> Enum.take(num)
  end
end
