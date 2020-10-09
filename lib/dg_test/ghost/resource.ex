defmodule DgTest.Ghost.Resource do
  @moduledoc false

  alias __MODULE__

  import DgTest.Ghost
  alias DgTest.Ghost.Post

  use Tesla, only: [:get]

  @type t :: %__MODULE__{name: binary}
  @type post :: Post.t()
  @type page :: keyword
  @enforce_keys [:name, :domain]
  defstruct [
    :name,
    :domain,
    :client,
    pages: [],
    items: []
  ]

  @per_page 10

  @spec all(t) :: list(post)
  def all(%Resource{} = resource) do
    resource
    |> pages_count()
    |> pages_fetch()
    |> pages_parse()
  end

  @spec fetch(t, pos_integer) :: list(post)
  def fetch(%Resource{name: name, client: client}, page) do
    query = [
      key: ghost_key(),
      page: page,
      limit: @per_page,
      include: "authors,tags"
    ]

    case get!(client, "/#{name}/", query: query) do
      %Tesla.Env{status: 200, body: body} -> body
    end
  end

  @spec pages_fetch(t) :: t
  def pages_fetch(%Resource{} = resource) do
    pages_fetch(resource, [])
  end

  defp pages_fetch(%Resource{pages: []} = resource, acc) do
    %{resource | pages: Enum.reverse(acc)}
  end

  defp pages_fetch(%Resource{pages: [p | pages]} = resource, acc) when is_map(p) do
    pages_fetch(%{resource | pages: pages}, [p | acc])
  end

  defp pages_fetch(%Resource{pages: [p | pages]} = resource, acc) do
    pages_fetch(%{resource | pages: pages}, [fetch(resource, p) | acc])
  end

  @spec pages_parse(t) :: list(post)
  def pages_parse(%Resource{domain: domain, name: name, pages: pages}) do
    Enum.flat_map(pages, &parse(domain, name, &1))
  end

  @spec pages_count(t) :: t
  def pages_count(%Resource{} = resource) do
    page = resource |> fetch(1)

    case max_page(page) do
      1 -> %{resource | pages: [page]}
      n -> %{resource | pages: [page | 2..n |> Enum.to_list()]}
    end
  end

  @spec parse(binary, binary, map) :: list(post)
  def parse(domain, name, page) do
    Map.get(page, name) |> Enum.map(&Post.new(Map.put(&1, "domain", domain)))
  end

  @spec max_page(page) :: pos_integer
  def max_page(page) do
    get_in(page, ["meta", "pagination", "pages"])
  end
end
