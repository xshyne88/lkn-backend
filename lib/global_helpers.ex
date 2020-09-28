defmodule GlobalHelpers do
  def snake_case(map) when is_map(map) do
    map
    |> Map.to_list()
    |> Enum.reduce(%{}, fn {key, value}, acc ->
      Map.put(acc, snake_case_key(key), snake_case(value))
    end)
  end

  def snake_case(map) when is_list(map), do: Enum.map(map, &snake_case/1)
  def snake_case(map), do: map

  defp snake_case_key(key) when is_atom(key) do
    key
    |> Atom.to_string()
    |> Macro.underscore()
    |> String.to_atom()
  end

  defp snake_case_key(key) when is_binary(key) do
    key
    |> Macro.underscore()
    |> String.to_atom()
  end

  defp snake_case_key(key), do: key

  def append_word_to_atom(atom, word) when is_atom(atom) do
    "#{atom}_#{word}" |> String.to_atom()
  end

  def prepend_word_to_atom(atom, word) when is_atom(atom) do
    "#{word}_#{atom}" |> String.to_atom()
  end
end
