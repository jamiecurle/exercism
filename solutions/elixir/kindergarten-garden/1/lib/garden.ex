defmodule Garden do
  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """

  @plants %{"G" => :grass, "C" => :clover, "R" => :radishes, "V" => :violets}
  @names ~w(alice bob charlie david eve fred ginny harriet ileana joseph kincaid larry)a

  def info(info_string, student_names \\ @names) do
    rows =
      String.split(info_string, "\n")
      |> Enum.map(&String.graphemes/1)

    student_names
    |> Enum.sort()
    |> Enum.with_index(fn element, index -> {index, element} end)
    |> Enum.reduce(%{}, &garden_for_student(&1, &2, rows))
  end

  defp garden_for_student({i, student}, results, rows) do
    garden =
      rows
      |> Enum.flat_map(fn row ->
        # index needs to be multiplied by two
        Enum.slice(row, (i * 2)..(i * 2 + 1))
      end)
      |> case do
        [a, b, c, d] ->
          {
            Map.get(@plants, a),
            Map.get(@plants, b),
            Map.get(@plants, c),
            Map.get(@plants, d)
          }

        _ ->
          {}
      end

    Map.put(results, student, garden)
  end
end
