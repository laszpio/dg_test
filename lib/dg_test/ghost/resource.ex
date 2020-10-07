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

  @enforce_keys [:name, :domain]
  defstruct [:name, :domain, :pages, :pages_count]

  @per_page 10

  @spec all(t) :: t
  def all(%Resource{domain: domain, name: name} = resource) do
    resource
    |> pages_count()
    # |> pages_fetch()
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

  def pages_fetch(%Resource{pages_count: 1, pages: pages} = resource) do
    %{resource | pages: pages}
  end

  def pages_fetch(%Resource{pages_count: n, pages: [page]} = resource) do
    %{resource | pages: [page | 2..n |> Enum.map(&fetch(resource, &1))]}
  end

  @spec pages_count(t) :: t
  def pages_count(%Resource{} = resource) do
    page = resource |> fetch(1)

    resource
    |> Map.put(:pages_count, max_page(page))
    |> Map.put(:pages, [page])
  end

  @spec parse(binary, binary, map) :: list(post)
  def parse(domain, name, page) do
    Map.get(page, name) |> Enum.map(&Post.new(Map.put(&1, "domain", domain)))
  end

  @spec max_page(map) :: pos_integer
  def max_page(page) do
    get_in(page, ["meta", "pagination", "pages"])
  end
end
