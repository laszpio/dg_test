defmodule DgTest.Ghost.Crawler do
  alias __MODULE__

  alias DgTest.Ghost.Resource

  @type t :: %__MODULE__{
          domain: binary,
          url: binary,
          key: binary
        }

  defstruct [:domain, :url, :key]

  def resources(%Crawler{domain: domain} = crawler) do
    [%Resource{domain: domain, name: "posts"}]
  end
end