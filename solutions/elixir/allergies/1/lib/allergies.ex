defmodule Allergies do
  @doc """
  List the allergies for which the corresponding flag bit is true.
  """
  @allergies %{
    "eggs" => 1,
    "peanuts" => 2,
    "shellfish" => 4,
    "strawberries" => 8,
    "tomatoes" => 16,
    "chocolate" => 32,
    "pollen" => 64,
    "cats" => 128
  }

  @spec list(non_neg_integer) :: [String.t()]
  def list(flags) do
    @allergies
    |> Enum.filter(fn {_allergen, score} ->
      Bitwise.band(flags, score) != 0
    end)
    |> Enum.map(fn {allergen, _score} -> allergen end)
  end

  @doc """
  Returns whether the corresponding flag bit in 'flags' is set for the item.
  """
  @spec allergic_to?(non_neg_integer, String.t()) :: boolean
  def allergic_to?(flags, item) do
    with score when score != nil <- Map.get(@allergies, item),
         value when value != 0 <- Bitwise.band(score, flags) do
      true
    else
      _ -> false
    end
  end
end
