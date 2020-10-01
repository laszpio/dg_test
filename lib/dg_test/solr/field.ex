defmodule DgTest.Solr.Field do
  @moduledoc false

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

  @spec from_list(list(map)) :: list(t)
  def from_list(list) do
    Enum.map(list, &new/1)
  end

  @spec to_solr(t) :: map
  def to_solr(field) do
    field |> Map.from_struct() |> Utils.solarize()
  end
end
