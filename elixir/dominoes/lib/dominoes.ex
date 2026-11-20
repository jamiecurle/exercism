defmodule Dominoes do
  # I don't need this as solution one doesn't work
  # require Integer

  @type domino :: {1..6, 1..6}

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino]) :: boolean
  def chain?(dominoes) do
    dominoes
    |> Enum.reduce(%{first: [], last: []}, fn {first, last}, acc ->
      IO.inspect(first)
      IO.inspect(last)
    end)
    # |> Enum.flat_map(fn {a, b} -> [a, b] end)
    # |> Enum.sort()
    |> IO.inspect()
  end

  # def chain_original?(dominoes) do
  #   # this was my initial attempt and it worked up intil the disconnected tests
  #   # get the frequencies and if they're all even, then we're good. But, it
  #   # failed to take into account the cases where you have pairs of dominoes
  #   # that won't chain
  #   dominoes
  #   |> Enum.flat_map(fn {a, b} -> [a, b] end)
  #   # |> IO.inspect(label: "map")
  #   |> Enum.frequencies()
  #   # |> IO.inspect(label: "frequencies")
  #   |> Enum.map(fn {_, count} -> Integer.is_even(count) end)
  #   # |> IO.inspect(label: "results")
  #   |> Enum.all?()
  # end
end
