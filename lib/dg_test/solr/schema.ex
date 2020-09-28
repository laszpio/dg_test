defmodule DgTest.Solr.Schema do
  use Tesla, only: [:get, :post]

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

  @spec info(binary) :: {:ok, t} | {:error, binary}
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
      |> Map.put(:copy_fields, schema["copyFields"])
      |> Map.put(:dynamic_fields, schema["dynamicFields"])
      |> Map.put(:field_types, schema["fieldTypes"])
      |> Map.put(:fields, schema["fields"])
      |> Map.put(:name, schema["name"])
      |> Map.put(:unique_key, schema["uniqueKey"])
      |> Map.put(:version, schema["version"])

    {:ok, schema}
  end

  @spec add_field(binary, binary, binary) :: :ok
  def add_field(core, name, type) do
    change = %{
      "add-field" => %{
        name: name,
        type: type,
        stored: true
      }
    }

    apply_change(core, change)
  end

  @spec remove_field(binary, binary, binary) :: :ok
  def remove_field(core, name) do
    change = %{"delete-field" => %{"name" => name}}

    apply_change(core, change)
  end

  def add_copy_field(core, source, dest) do
    change = %{
      "add-copy-field" => %{
        source: source,
        dest: dest
      }
    }

    apply_change(core, change)
  end

  def remove_copy_field(core, source, dest) do
    change = %{
      "add-copy-field" => %{
        source: source,
        dest: dest
      }
    }

    apply_change(core, change)
  end

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

  def client() do
    Tesla.client(middleware())
  end

  def middleware() do
    [
      {Tesla.Middleware.BaseUrl, DgTest.solr_url()},
      {Tesla.Middleware.JSON, decode_content_types: ["text/plain"]},
      {Tesla.Middleware.Logger, log_level: :info}
    ]
  end
end
