defmodule DgTest.Ghost.Resource do
  @moduledoc false
  
  use Tesla

  import DgTest.Ghost

  plug(Tesla.Middleware.BaseUrl, ghost_url())
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.Logger, log_level: :info)
  
  defstruct [:name]
  
  def all(name) do
    page = fetch(name, 1)

    case page_max(page) do
      1 -> [page]
      n -> [page | 2..n |> Enum.map(&fetch(name, &1))]
    end
    |> Enum.map(&parse(name, &1))
    |> Enum.to_list()
    |> List.flatten()
  end
  
  def fetch(resource, page) do
    case get("/#{resource}/", query: query(page)) do
      {:ok, resp} -> resp.body
    end
  end
  
  def query(page) do
    [key: ghost_key(), page: page, include: "authors,tags"]
  end

  def parse(resource, page) do
    Map.get(page, resource) |> Enum.map(&DgTest.Ghost.Post.new/1)
  end

  def page_max(page) do
    page |> get_in(["meta", "pagination", "pages"])
  end
end