defmodule DgTest.Solr.Schema do
  @moduledoc false

  alias DgTest.Solr.Utils
  alias DgTest.Solr.Field
  alias DgTest.Solr.SchemaApi

  @typedoc """
  Struct for the common and SolrCloud schema.
  """
  @type t :: %__MODULE__{
          name: binary,
          unique_key: binary,
          version: float,
          copy_fields: list,
          dynamic_fields: list,
          field_types: list,
          fields: list
        }

  defstruct [
    :name,
    :unique_key,
    :version,
    copy_fields: [],
    dynamic_fields: [],
    field_types: [],
    fields: []
  ]

  def new(schema) do
    %__MODULE__{}
    |> Utils.to_struct(schema)
    |> Map.update!(:fields, &Field.from_list(&1))
    |> Map.update!(:dynamic_fields, &Field.from_list(&1))
  end

  @spec info(binary | atom) :: {:ok, t} | {:error, binary}
  def info(core) do
    case SchemaApi.info(core) do
      %Tesla.Env{status: 200, body: body} -> parse_info(body)
      %Tesla.Env{status: 404} -> {:error, "Core '#{core}' doesn't exist."}
    end
  end

  @spec parse_info(map) :: {:ok, t}
  defp parse_info(%{"schema" => schema}), do: {:ok, new(schema)}

  @spec add_field(atom | binary, binary, binary, keyword) :: :ok | {:error, binary}
  def add_field(core, name, type, opts \\ []) do
    change = %{
      "add-field" => %{
        name: name,
        type: type,
        stored: true,
        multiValued: Keyword.get(opts, :multi_valued, false),
        uninvertible: Keyword.get(opts, :uninvertible, false)
      }
    }

    apply_change(core, change)
  end

  @spec remove_field(binary, binary) :: :ok | {:error, binary}
  def remove_field(core, name) do
    change = %{"delete-field" => %{"name" => name}}

    apply_change(core, change)
  end

  @spec add_copy_field(atom | binary, binary, binary) :: :ok | {:error, binary}
  def add_copy_field(core, source, dest) do
    change = %{
      "add-copy-field" => %{
        source: source,
        dest: dest
      }
    }

    apply_change(core, change)
  end

  @spec remove_copy_field(binary, binary, binary) :: :ok | {:error, binary}
  def remove_copy_field(core, source, dest) do
    change = %{
      "add-copy-field" => %{
        source: source,
        dest: dest
      }
    }

    apply_change(core, change)
  end

  @spec apply_change(binary | atom, map) :: :ok | {:error, binary}
  def apply_change(core, change) do
    case SchemaApi.change(core, change) do
      %Tesla.Env{status: 200, body: body} -> parse_response(body)
      %Tesla.Env{status: 400, body: body} -> parse_response(body)
    end
  end

  defp parse_response(%{"responseHeader" => %{"status" => 0}}), do: :ok

  defp parse_response(%{"error" => %{"details" => error}}), do: {:error, error}
end
