defmodule DgTest do
  use Tesla

  plug Tesla.Middleware.BaseUrl, ghost_url()
  plug Tesla.Middleware.JSON

  def posts() do
    page = posts(1)
    pages = [page | 2..page_max(page) |> Enum.map(&posts/1)]

    pages
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
      id: Map.get(post, "id"),
      slug: Map.get(post, "slug"),
      title: Map.get(post, "title"),
      tags: parse_tags(post),
      authors: parse_authors(post),
      content: parse_content(post)
    }
  end

  def parse_authors(post) do
    post |> Map.get("authors") |> Enum.map(&Map.get(&1, "name"))
  end

  def parse_tags(post) do
    post |> Map.get("tags") |> Enum.map(&Map.get(&1, "name"))
  end

  def parse_content(post) do
    post |> Map.get("html") |> HtmlSanitizeEx.strip_tags()
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
