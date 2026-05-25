defmodule MatchingBrackets do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str) do
    str
    |> String.graphemes()
    # build a stack of brackets
    |> Enum.reduce_while([], &build_stack/2)
    |> case do
      # an empty stack indicates every bracket was parsed
      [] -> true
      # the stack can have two invalid states
      # :invalid or none empty list
      :invalid -> false
      [_ | _] -> false
    end
  end

  # opening brackets are always valid
  defp build_stack(bracket, stack) when bracket in ["[", "{", "("] do
    {:cont, [bracket | stack]}
  end

  defp build_stack(bracket, stack) when bracket in ["]", "}", ")"] do
    # closing brackets need to be validated. If they're valid
    # the continue with the tail (popping)
    if valid?(bracket, stack) do
      [_head | tail] = stack
      {:cont, tail}
    else
      # invalid, obviously
      {:halt, :invalid}
    end
  end

  # letters, spaces, non-brackets characters. This is
  # what turns the entire thing into a usable parser
  defp build_stack(_, stack), do: {:cont, stack}

  # any closing bracket on a empty stack is invalid
  defp valid?(bracket, []) when bracket in ["]", "}", ")"], do: false

  # ensure closing matches opening of type
  defp valid?(bracket, [head | _tail]) do
    cond do
      bracket == "]" && head == "[" -> true
      bracket == "}" && head == "{" -> true
      bracket == ")" && head == "(" -> true
      true -> false
    end
  end
end
