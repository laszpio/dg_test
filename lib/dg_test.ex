defmodule DgTest do
  @moduledoc false

  import DgTest.Solr
  alias DgTest.Solr.Cores
  alias DgTest.Solr.Schema

  import DgTest.Ghost

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
    |> Enum.map(&Map.from_struct/1)
  end

  def posts(page) do
    {:ok, resp} = get("/posts/", query: [key: ghost_key(), page: page, include: "authors,tags"])
    resp.body
  end

  def parse_posts(page) do
    Map.get(page, "posts") |> Enum.map(&DgTest.Ghost.Post.new/1)
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
