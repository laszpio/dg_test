defmodule DgTest do
  @moduledoc false

  import HtmlSanitizeEx

  import DgTest.Solr
  alias DgTest.Solr.Cores
  alias DgTest.Solr.Schema

  use Tesla

  plug(Tesla.Middleware.BaseUrl, ghost_url())
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.Logger, log_level: :info)

  def reindex_posts() do
    Hui.update(posts_target(), posts())
  end

  def posts_target() do
    headers = [{"Content-type", "application/json"}]
    %Hui.URL{url: target_url(), handler: "update", headers: headers}
  end

  def posts() do
    page = posts(1)

    case page_max(page) do
      1 -> [page]
      n -> [page | 2..n |> Enum.map(&posts/1)]
    end
    |> Enum.map(&parse_posts/1)
    |> Enum.to_list()
    |> List.flatten()
  end

  def posts(page) do
    {:ok, resp} = get("/posts/", query: [key: ghost_key(), page: page, include: "authors,tags"])
    resp.body
  end

  def parse_posts(page) do
    Map.get(page, "posts") |> Enum.map(&parse_post/1)
  end

  def parse_post(post) do
    %{
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

  def ghost_url do
    Application.fetch_env!(:dg_test, :ghost_url)
  end

  def ghost_key do
    Application.fetch_env!(:dg_test, :ghost_key)
  end

  def page_max(page) do
    page |> get_in(["meta", "pagination", "pages"])
  end

  @spec recreate_index() :: no_return()
  def recreate_index do
    Cores.delete("items")
    Cores.create("items")
    Schema.add_field(:items, "domain", "string")
    Schema.add_field(:items, "slug", "string")
    Schema.add_field(:items, "title", "text_en")
    Schema.add_field(:items, "tags", "text_en", multi_valued: true)
    Schema.add_field(:items, "authors", "text_en", multi_valued: true)
    Schema.add_field(:items, "content", "text_en")
    Schema.add_field(:items, "created_at", "pdate")
    Schema.add_copy_field(:items, "*", "_text_")
  end
end
