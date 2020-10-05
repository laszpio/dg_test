defmodule DgTest.Ghost.Post do
  @moduledoc false

  alias __MODULE__

  import HtmlSanitizeEx

  @mapping [content: :html]
  @collect [authors: :name, tags: :name]

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
    Enum.reduce(Map.to_list(%Post{}), %Post{}, fn {k, default}, acc ->
      case Map.fetch(post, (Keyword.get(@mapping, k) || k) |> Atom.to_string) do
        {:ok, v} -> %{acc | k => extract(k, v, default)}
        :error -> acc
      end
    end)
  end

  def extract(key, value, []) do
    value
    |> Enum.map(&Map.get(&1, Keyword.get(@collect, key) |> Atom.to_string))
    |> Enum.map(&strip_tags/1)
  end

  def extract(_key, value, _default) do
    value |> strip_tags()
  end
end
