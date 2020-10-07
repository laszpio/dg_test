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
  defstruct [
    :name,
    :domain,
    pages: [],
    items: []
  ]

  @per_page 10

  @spec all(t) :: t
  def all(%Resource{domain: domain, name: name} = resource) do
    resource
    |> pages_count()
    |> pages_fetch()

    # |> pages_fetch()
    # |> pages_parse()
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

  def pages_fetch(%Resource{} = resource) do
    pages_fetch(resource, [])
  end

  def pages_fetch(%Resource{pages: []} = resource, acc) do
    %{resource | pages: Enum.reverse(acc)}
  end

  def pages_fetch(%Resource{name: name, pages: [p | pages]} = resource, acc) when is_map(p) do
    pages_fetch(%{resource | pages: pages}, [p | acc])
  end

  def pages_fetch(%Resource{name: name, pages: [p | pages]} = resource, acc) do
    pages_fetch(%{resource | pages: pages}, [fetch(resource, p) | acc])
  end

  # def pages_fetch(%Resource{pages_count: 1, pages: pages} = resource) do
  #   %{resource | pages: pages}
  # end
  #
  # def pages_fetch(%Resource{pages_count: n, pages: [page]} = resource) do
  #   %{resource | pages: [page | 2..n |> Enum.map(&fetch(resource, &1))]}
  # end
  #
  # def pages_parse(%Resource{domain: domain, name: name, pages: pages} = resource) do
  #   %{resource | pages: Enum.map(pages, &parse(domain, name, &1)) |> Enum.to_list |> List.flatten}
  # end

  @spec pages_count(t) :: t
  def pages_count(%Resource{} = resource) do
    page = resource |> fetch(1)

    %{
      resource
      | pages:
          case max_page(page) do
            1 -> [page]
            n -> [page | 2..n |> Enum.to_list]
          end
    }
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
