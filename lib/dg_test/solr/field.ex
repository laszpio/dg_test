defmodule DgTest.Solr.Field do
  alias DgTest.Solr.Utils

  @type t :: %__MODULE__{
    name: binary,
    type: binary,
    indexed: binary,
    required: boolean,
    stored: boolean,
    uninvertible: boolean
  }

  defstruct [
    :name,
    :indexed,
    :required,
    :stored,
    :type,
    :uninvertible
  ]

  def new(field) do
    Utils.to_struct(%__MODULE__{}, field)
  end
end
