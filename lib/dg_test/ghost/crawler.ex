defmodule DgTest.Ghost.Crawler do
  alias __MODULE__

  use Tesla

  import DgTest.Ghost
  alias DgTest.Ghost.Resource

  @type t :: %__MODULE__{
          domain: binary,
          url: binary,
          key: binary
        }

  defstruct [:domain, :url, :key]

  @resources ~w(posts pages)

  def resources(%Crawler{domain: domain} = _crawler) do
    Enum.map(@resources, &%Resource{domain: domain, name: &1, client: client()})
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
