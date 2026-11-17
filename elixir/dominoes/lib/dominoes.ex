defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino]) :: boolean
  def chain?(dominoes) do
    dominoes
    |> Enum.flat_map(fn {a, b} ->
      [a, b]
    end)
    |> Enum.sort()
    |> IO.inspect()

    true
  end
end
