defmodule DgTest.Solr.Utils do
  @moduledoc false

  @spec to_struct(struct, map) :: struct
  def to_struct(kind, attrs) do
    struct = struct(kind)

    Enum.reduce(Map.to_list(struct), struct, fn {k, _}, acc ->
      case Map.fetch(attrs, solarize(k)) do
        {:ok, v} -> %{acc | k => v}
        :error -> acc
      end
    end)
  end

  @spec solarize(atom) :: binary
  def solarize(attr) when is_atom(attr) do
    attr |> Atom.to_string() |> solarize()
  end

  @spec solarize(binary) :: binary
  def solarize(attr) when is_binary(attr) do
    attr |> Macro.camelize() |> lower_first()
  end

  @spec solarize(map) :: map
  def solarize(map) do
    Map.new(map, fn {k, v} -> {solarize(k), v} end)
  end

  defp lower_first(<<>>), do: ""

  defp lower_first(<<first::binary-size(1)>> <> rest) do
    String.downcase(first) <> rest
  end
end
