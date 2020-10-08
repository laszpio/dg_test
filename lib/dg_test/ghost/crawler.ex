defmodule DgTest.Ghost.Crawler do
  alias __MODULE__

  alias DgTest.Ghost.Resource

  @type t :: %__MODULE__{
          domain: binary,
          url: binary,
          key: binary
        }

  defstruct [:domain, :url, :key]

  @resources ~w(posts pages)

  def resources(%Crawler{domain: domain} = crawler) do
    Enum.map(@resources, &%Resource{domain: domain, name: &1})
  end
end