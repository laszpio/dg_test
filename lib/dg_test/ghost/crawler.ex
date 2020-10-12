defmodule DgTest.Ghost.Crawler do
  alias __MODULE__

  alias DgTest.Ghost.Resource

  @type t :: %__MODULE__{domain: binary}

  defstruct [:domain, :resources, :items]

  @resources ~w(posts)

  @spec resources(t) :: t
  def resources(%Crawler{domain: domain} = crawler) do
    Map.put(crawler, :resources, Enum.map(@resources, &%Resource{domain: domain, name: &1}))
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
