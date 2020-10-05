defmodule DgTest.Ghost.Post do
  @moduledoc false

  import HtmlSanitizeEx

  defstruct [
    :id,
    :domain,
    :slug,
    :title,
    :content,
    :created_at,
    tags: [],
    authors: [],
  ]

  def new(post) do
    %__MODULE__{
      id: parse_id(post),
      domain: "https://productmarketingalliance.com",
      slug: Map.get(post, "slug"),
      title: Map.get(post, "title"),
      tags: parse_tags(post),
      authors: parse_authors(post),
      content: parse_content(post),
      created_at: parse_created_at(post)
    }
  end

  def parse_id(post) do
    post |> Map.get("id") |> strip_tags()
  end

  def parse_slug(post) do
    post |> Map.get("slug") |> strip_tags()
  end

  def parse_title(post) do
    post |> Map.get("title") |> strip_tags()
  end

  def parse_authors(post) do
    post
    |> Map.get("authors")
    |> Enum.map(&Map.get(&1, "name"))
    |> Enum.map(&strip_tags/1)
  end

  def parse_tags(post) do
    post
    |> Map.get("tags")
    |> Enum.map(&Map.get(&1, "name"))
    |> Enum.map(&strip_tags/1)
  end

  def parse_content(post) do
    post |> Map.get("html") |> strip_tags()
  end

  def parse_created_at(post) do
    post |> Map.get("created_at") |> strip_tags()
  end
end
