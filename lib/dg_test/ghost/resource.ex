defmodule DgTest.Ghost.Resource do
  @moduledoc false

  alias __MODULE__
  
  import DgTest.Ghost
  alias DgTest.Ghost.Post

  use Tesla

  plug(Tesla.Middleware.BaseUrl, ghost_url())
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.Logger, log_level: :info)
  
  @type t :: %__MODULE__{name: binary}
  @type post :: Post.t()

  @enforce_keys [:name]
  defstruct [:name, :pages, :pages_count]
  
  @per_page 10

  @spec all(t) :: list(post)
  def all(%Resource{name: name} = resource) do
    page = fetch(resource, 1)
    
    case max_page(page) do
      1 -> [page]
      n -> [page | 2..n |> Enum.map(&fetch(resource, &1))]
    end
    |> Enum.map(&parse(name, &1))
    |> Enum.to_list()
    |> List.flatten()
  end

  @spec fetch(t, pos_integer) :: map
  def fetch(%Resource{name: name}, page) do
    query = [
      key: ghost_key(),
      page: page,
      limit: @per_page,
      include: "authors,tags"
    ]

    case get!("/#{name}/", query: query) do
      %Tesla.Env{status: 200, body: body} -> body
    end
  end
  
  @spec pages_count(t) :: t
  def pages_count(%Resource{} = resource) do
    page = resource |> fetch(1)
    
    resource 
    |> Map.put(:pages_count, max_page(page))
    |> Map.put(:pages, [page])
  end

  def parse(resource, page) do
    Map.get(page, resource) |> Enum.map(&Post.new/1)
  end

  @spec max_page(map) :: pos_integer
  def max_page(page) do
    get_in(page, ["meta", "pagination", "pages"])
  end
end
