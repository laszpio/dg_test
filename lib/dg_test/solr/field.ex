defmodule DgTest.Solr.Field do
  alias DgTest.Solr.Utils

  @type t :: %__MODULE__{
          name: binary,
          type: binary,
          indexed: binary,
          required: boolean,
          stored: boolean,
          uninvertible: boolean,
          multi_valued: boolean
        }

  defstruct [
    :name,
    :indexed,
    :required,
    :stored,
    :type,
    :uninvertible,
    :multi_valued
  ]

  @spec new(map) :: t
  def new(field) do
    Utils.to_struct(%__MODULE__{}, field)
  end

  @spec to_solr(t) :: map
  def to_solr(field) do
    Map.from_struct(field)
  end
end
