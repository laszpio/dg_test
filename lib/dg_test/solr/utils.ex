defmodule DgTest.Solr.Utils do
  def to_struct(kind, attrs) do
    struct = struct(kind)

    Enum.reduce(Map.to_list(struct), struct, fn {k, _}, acc ->
      case Map.fetch(attrs, solarize(k)) do
        {:ok, v} -> %{acc | k => v}
        :error -> acc
      end
    end)
  end

  def solarize(attr) when is_atom(attr) do
    attr |> Atom.to_string() |> solarize()
  end

  def solarize(attr) when is_binary(attr) do
    attr |> Macro.camelize() |> lower_first()
  end

  def solarize(map) do
    Map.new(map, fn {k, v} -> {solarize(k), v} end)
  end

  defp lower_first(""), do: ""

  defp lower_first(<<first::binary-size(1)>> <> rest) do
    String.downcase(first) <> rest
  end
end
