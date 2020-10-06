defmodule DgTest.Ghost.Resource do
  @moduledoc false

  alias __MODULE__
  

  import DgTest.Ghost
  alias DgTest.Ghost.Post

  use Tesla

  plug(Tesla.Middleware.BaseUrl, ghost_url())
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.Logger, log_level: :info)
  
  @type resource :: %__MODULE__{name: binary}
  @type post :: Post.t()

  @enforce_keys [:name]
  defstruct [:name]

  @spec all(resource) :: list(post)
  def all(%Resource{name: name} = resource) do
    page = fetch(resource, 1)

    case page_max(page) do
      1 -> [page]
      n -> [page | 2..n |> Enum.map(&fetch(resource, &1))]
    end
    |> Enum.map(&parse(name, &1))
    |> Enum.to_list()
    |> List.flatten()
  end

  @spec fetch(resource, pos_integer) :: map
  def fetch(%Resource{name: name}, page) do
    query = [
      key: ghost_key(),
      page: page,
      per_page: 10,
      include: "authors,tags"
    ]

    case get!("/#{name}/", query: query) do
      %Tesla.Env{status: 200, body: body} -> body
    end
  end

  def parse(resource, page) do
    Map.get(page, resource) |> Enum.map(&Post.new/1)
  end

  def page_max(page) do
    page |> get_in(["meta", "pagination", "pages"])
  end
end
