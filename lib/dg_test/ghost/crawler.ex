defmodule DgTest.Ghost.Crawler do
  alias __MODULE__

  import DgTest.Ghost
  alias DgTest.Ghost.Resource

  @type t :: %__MODULE__{domain: binary}

  defstruct [:domain, :resources, :items]

  @resources ~w(posts)

  def new(domain) do
    %Crawler{domain: domain}
  end

  def resources(%Crawler{domain: domain} = crawler) do
    Map.put(crawler, :resources, Enum.map(@resources, &%Resource{domain: domain, name: &1}))
  end

  def fetch(%Crawler{resources: resources} = crawler) do
    %{crawler | items: Enum.flat_map(resources, &Resource.all/1)}
  end

  def items(%Crawler{items: items} = _crawler) do
    items
  end
end
