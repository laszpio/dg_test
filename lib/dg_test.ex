defmodule DgTest do
  import HtmlSanitizeEx

  use Tesla

  plug Tesla.Middleware.BaseUrl, ghost_url()
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Logger, log_level: :info


  def reindex_posts() do
    Hui.update(posts_target(), posts())
  end

  def posts_target() do
    headers = [{"Content-type", "application/json"}]
    %Hui.URL{url: "http://localhost:8983/solr/posts", handler: "update", headers: headers}
  end

  def target_url() do
    Enum.join([solr_url(), solr_core()], "/")
  end

  def solr_url() do
    Application.fetch_env!(:dg_test, :solr_url)
  end

  def solr_core() do
    Application.fetch_env!(:dg_test, :solr_core)
  end

  def posts() do
    page = posts(1)

    case page_max(page) do
      1 -> [page]
      n -> [page | 2..page_max(page) |> Enum.map(&posts/1)]
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
      html: parse_content(post)
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

  def ghost_url do
    Application.fetch_env!(:dg_test, :ghost_url)
  end

  def ghost_key do
    Application.fetch_env!(:dg_test, :ghost_key)
  end

  def page_max(page) do
    page |> get_in(["meta", "pagination", "pages"])
  end
end
