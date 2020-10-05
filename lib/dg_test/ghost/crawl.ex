defmodule DgTest.Ghost.Crawl do
  use Tesla

  import DgTest.Ghost

  plug(Tesla.Middleware.BaseUrl, ghost_url())
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.Logger, log_level: :info)

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
end
