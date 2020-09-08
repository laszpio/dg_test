defmodule DgTest do
  use Tesla

  plug Tesla.Middleware.BaseUrl, ghost_url()
  plug Tesla.Middleware.JSON

  def posts() do
    page = posts(1)
  end

  def posts(page) do
    {:ok, resp} = get("/posts/", query: [key: ghost_key(), page: page, include: "authors,tags"])
    resp.body
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
