defmodule IsbnVerifier do
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> IsbnVerifier.isbn?("3-598-21507-X")
      true

      iex> IsbnVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) do
    isbn
    |> String.replace("-", "")
    |> sum_isbn()
  end

  defp sum_isbn(isbn) when byte_size(isbn) > 10 or byte_size(isbn) < 10, do: false

  defp sum_isbn(isbn) do
    isbn
    |> String.split("", trim: true)
    |> Enum.reduce({10, 0}, fn x, {i, acc} ->
      x =
        cond do
          x == "X" and i == 1 -> 10
          x in ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"] -> String.to_integer(x)
          true -> 1
        end

      {i - 1, x * i + acc}
    end)
    |> then(fn {_i, result} -> rem(result, 11) == 0 end)
  end
end
