defmodule DgTest.Solr.Schema do
  use Tesla, only: [:get, :post]

  alias DgTest.Solr.Field

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

  @spec info(binary | atom) :: {:ok, t} | {:error, binary}
  def info(core) do
    case get!(client(), "/#{core}/schema") do
      %Tesla.Env{status: 200, body: body} -> parse_info(body)
      %Tesla.Env{status: 404} -> {:error, "Core '#{core}' doesn't exist."}
    end
  end

  @spec parse_info(map) :: {:ok, t}
  def parse_info(%{"schema" => schema}) do
    schema =
      %__MODULE__{}
      |> Map.put(:copy_fields, Map.get(schema, "copyFields"))
      |> Map.put(:dynamic_fields, Map.get(schema, "dynamicFields") |> Enum.map(&Field.new/1))
      |> Map.put(:field_types, Map.get(schema, "fieldTypes"))
      |> Map.put(:fields, Map.get(schema, "fields") |> Enum.map(&Field.new/1))
      |> Map.put(:name, Map.get(schema, "name"))
      |> Map.put(:unique_key, Map.get(schema, "uniqueKey"))
      |> Map.put(:version, Map.get(schema, "version"))

    {:ok, schema}
  end

  @spec add_field(binary, binary, binary, keyword) :: :ok | {:error, binary}
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

  @spec add_copy_field(binary, binary, binary) :: :ok | {:error, binary}
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

  @spec apply_change(binary, map) :: :ok | {:error, binary}
  def apply_change(core, change) do
    case post!(client(), "/#{core}/schema", change) do
      %Tesla.Env{status: 200, body: body} -> parse_response(body)
      %Tesla.Env{status: 400, body: body} -> parse_response(body)
    end
  end

  def parse_response(%{"responseHeader" => %{"status" => 0}}) do
    :ok
  end

  def parse_response(%{"error" => %{"details" => details}}) do
    {:error, details}
  end

  @spec client() :: %Tesla.Client{}
  def client() do
    Tesla.client(middleware())
  end

  @spec middleware() :: list(tuple)
  def middleware() do
    [
      {Tesla.Middleware.BaseUrl, DgTest.solr_url()},
      {Tesla.Middleware.JSON, decode_content_types: ["text/plain"]},
      {Tesla.Middleware.Logger, log_level: :info}
    ]
  end
end
