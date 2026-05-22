defmodule Atbash do
  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples
  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  @spec encode(String.t()) :: String.t()
  def encode(plaintext) do
    plaintext
    |> String.downcase()
    |> String.graphemes()
    |> Enum.map(&atbash_encode/1)
    |> Enum.filter(&(&1 != ""))
    |> Enum.chunk_every(5)
    |> Enum.map_join(" ", & &1)
  end

  @spec decode(String.t()) :: String.t()
  def decode(cipher) do
    cipher
    |> String.graphemes()
    |> Enum.map_join(&atbash_decode/1)
  end

  defp atbash_decode(encoded) do
    Map.merge(
      decode_map(),
      number_map()
    )
    |> Map.get(encoded, "")
  end

  defp atbash_encode(unencoded) do
    Map.merge(
      encode_map(),
      number_map()
    )
    |> Map.get(unencoded, "")
  end

  defp decode_map do
    97..122
    |> Map.new(fn code -> {<<219 - code>>, <<code>>} end)
  end

  defp encode_map do
    97..122
    |> Map.new(fn code -> {<<code>>, <<219 - code>>} end)
  end

  defp number_map do
    48..57
    |> Map.new(fn code -> {<<code>>, <<code>>} end)
  end
end
