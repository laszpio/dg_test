defmodule DgTest.Ghost.Crawler do
  @type t :: %__MODULE__{
          url: binary,
          key: binary
        }

  defstruct [:url, :key]
end