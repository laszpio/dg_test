defmodule DgTest.Ghost.Crawler do
  alias __MODULE__

  alias DgTest.Ghost.Resource

  @type t :: %__MODULE__{domain: binary}

  defstruct [:domain, :resources, :items, :api_url, :api_key]

  @resources ~w(posts pages)

  @spec connect(t) :: t
  def connect(%Crawler{domain: domain, api_url: api_url, api_key: api_key} = crawler) do
    DgTest.Ghost.connect(domain, api_url, api_key)

    %{crawler | api_url: nil, api_key: nil}
  end

  @spec resources(t) :: t
  def resources(%Crawler{domain: domain} = crawler) do
    %{crawler | resources: Enum.map(@resources, &%Resource{domain: domain, name: &1})}
  end

  @spec fetch(t) :: t
  def fetch(%Crawler{resources: resources} = crawler) do
    %{crawler | items: Enum.flat_map(resources, &Resource.all/1)}
  end

  @spec items(t) :: list(map)
  def items(%Crawler{items: items} = _crawler) do
    Enum.map(items, &Map.from_struct/1)
  end
end
