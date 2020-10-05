defmodule DgTest.Ghost.Post do
  @moduledoc false

  import HtmlSanitizeEx

  @mapping [content: :html]

  defstruct [
    :id,
    :slug,
    :title,
    :content,
    :created_at,
    domain: "https://productmarketingalliance.com",
    tags: [],
    authors: [],
  ]

  def new(post) do
    Enum.reduce(Map.to_list(%__MODULE__{}), %__MODULE__{}, fn {k, default}, acc ->
      case Map.fetch(post, (Keyword.get(@mapping, k) || k) |> Atom.to_string) do
        {:ok, v} -> %{acc | k => parse_attr(v, default)}
        :error -> acc
      end
    end)
  end

  def parse_attr(value, []) do
    value |> Enum.map(&Map.get(&1, "name")) |> Enum.map(&strip_tags/1)
  end

  def parse_attr(value, _default) do
    value |> strip_tags()
  end
end
