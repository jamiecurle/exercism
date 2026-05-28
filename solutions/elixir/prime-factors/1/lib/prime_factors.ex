defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(number) do
    do_factors([], number, 2)
  end

  def do_factors(factors, n, d) when d <= n do
    if rem(n, d) == 0 do
      do_factors([d | factors], div(n, d), d)
    else
      do_factors(factors, n, d + 1)
    end
  end

  def do_factors(factors, _n, _d), do: factors |> Enum.reverse()
end
