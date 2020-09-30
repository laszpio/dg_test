defmodule DgTest.Solr.Utils do
  def to_struct(kind, attrs) do
    struct = struct(kind)

    Enum.reduce(Map.to_list(struct), struct, fn {k, _}, acc ->
      case Map.fetch(attrs, to_solr(k)) do
        {:ok, v} -> %{acc | k => v}
        :error -> acc
      end
    end)
  end

  def to_solr(attr) when is_atom(attr) do
    attr
    |> Atom.to_string()
    |> Macro.camelize()
    |> lower_first()
    |> String.to_atom()
  end

  defp lower_first(""), do: ""

  defp lower_first(<<first::binary-size(1)>> <> rest) do
    String.downcase(first) <> rest
  end
end
