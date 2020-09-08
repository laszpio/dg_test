defmodule DgTest do
  use Tesla

  plug Tesla.Middleware.BaseUrl, ghost_url()
  plug Tesla.Middleware.JSON

  def posts() do
    get("/posts/", query: [key: ghost_key(), include: "authors,tags"])
  end

  def ghost_url do
    Application.fetch_env!(:dg_test, :ghost_url)
  end

  def ghost_key do
    Application.fetch_env!(:dg_test, :ghost_key)
  end
end
