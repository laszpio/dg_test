defmodule DgTest.Solr.Field do
  alias DgTest.Solr.Utils

  @type t :: %__MODULE__{
          name: binary,
          type: binary,
          indexed: binary,
          required: boolean,
          stored: boolean,
          uninvertible: boolean,
          multivalued: boolean
        }

  defstruct [
    :name,
    :indexed,
    :required,
    :stored,
    :type,
    :uninvertible,
    :multivalued
  ]

  @spec new(map) :: t
  def new(field) do
    Utils.to_struct(%__MODULE__{}, field)
    |> Map.put(:multivalued, field["multiValued"])
  end

  @spec to_param(t) :: map
  def to_param(field) do
    field
  end
end
