defmodule DgTest.Ghost.Crawler do
  alias __MODULE__

  use Tesla, only: [:get]

  import DgTest.Ghost
  alias DgTest.Ghost.Resource

  @type t :: %__MODULE__{domain: binary}

  defstruct [:domain, :resources, :items]

  @resources ~w(posts)

  def new(domain) do
    %Crawler{domain: domain}
  end

  def resources(%Crawler{domain: domain} = crawler) do
    %{crawler | resources: Enum.map(@resources, &%Resource{domain: domain, name: &1, client: client()})}
  end

  def fetch(%Crawler{resources: resources} = crawler) do
    %{crawler | items: Enum.flat_map(resources, &Resource.all/1)}
  end

  def items(%Crawler{items: items} = crawler) do
    items
  end

  def client do
    middleware = [
      {Tesla.Middleware.BaseUrl, ghost_url()},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Logger, log_level: :info}
    ]

    Tesla.client(middleware)
  end
end
