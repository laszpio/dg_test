defmodule DgTest.Ghost.Item do
  @moduledoc false

  alias __MODULE__
  import DgTest.Ghost.Timestamp

  @mapping [content: :html]
  @collect [authors: :name, tags: :name]

  @type t :: %__MODULE__{
          id: binary,
          slug: binary,
          title: binary,
          content: binary,
          published_at: binary,
          created_at: binary,
          domain: binary,
          tags: list,
          authors: list
        }

  defstruct [
    :id,
    :resource,
    :domain,
    :slug,
    :title,
    :content,
    :published_at,
    :created_at,
    tags: [],
    authors: []
  ]

  @spec new(map) :: t
  def new(source) do
    Enum.reduce(Map.to_list(%Item{}), %Item{}, fn {k, default}, acc ->
      attr = (Keyword.get(@mapping, k) || k) |> Atom.to_string()
      source = Map.merge(source, %{created_at: utc_timestamp()})

      case Map.fetch(source, attr) do
        {:ok, v} -> %{acc | k => extract(k, v, default)}
        :error -> acc
      end
    end)
  end

  @spec extract(atom, list, list) :: list(binary)
  def extract(key, value, default) when is_list(default) do
    value
    |> Enum.map(&Map.get(&1, Keyword.get(@collect, key) |> Atom.to_string()))
    |> Enum.map(&sanitize/1)
  end

  @spec extract(atom, binary, nil | binary) :: nil | binary
  def extract(_key, value, default) do
    case sanitize(value) do
      <<>> -> default
      v -> v
    end
  end

  @spec sanitize(binary) :: binary
  def sanitize(value) do
    value
    |> HtmlSanitizeEx.strip_tags()
    |> String.trim()
  end
end
