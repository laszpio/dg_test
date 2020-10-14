defmodule DgTest.Solr.Cores do
  @moduledoc false

  alias DgTest.Solr.Client
  alias DgTest.Solr.AdminCmd

  @spec status() :: {:ok, map} | {:error, binary}
  def status do
    case Client.get("admin/cores", query: [action: "STATUS"]) do
      {:ok, %Tesla.Env{status: 200, body: body}} -> parse_status(body)
      {:error, msg} -> {:error, msg}
    end
  end

  @spec status(binary | atom) :: {:ok, map} | {:error, binary}
  def status(core) do
    case Client.get("admin/cores", query: [action: "STATUS", core: core]) do
      {:ok, %Tesla.Env{status: 200, body: body}} -> parse_status(body, core)
      {:error, msg} -> {:error, msg}
    end
  end

  def parse_status(%{"status" => status}) do
    {:ok, status}
  end

  def parse_status(%{"status" => status}, core) do
    case Map.get(status, core) == %{} do
      true -> {:error, "Core '#{core}' doesn't exist."}
      false -> {:ok, status}
    end
  end

  @spec cores() :: list(binary)
  def cores do
    {:ok, status} = status()
    Map.keys(status)
  end

  @spec exists?(binary) :: boolean
  def exists?(core), do: core in cores()

  @spec ping(binary) :: :ok | :error
  def ping(core) do
    case Client.get!("/#{core}/admin/ping") do
      %Tesla.Env{status: 200} -> :ok
      %Tesla.Env{status: 404} -> :error
    end
  end

  @spec create(binary) :: {:ok, binary} | {:error, binary}
  def create(core) do
    case AdminCmd.run("create -c #{core}") do
      {:ok, _} -> {:ok, "Created new core '#{core}'"}
      {:error, _} -> {:error, "Core '#{core}' already exists"}
    end
  end

  @spec create!(binary) :: :ok
  def create!(core) do
    create(core)
    :ok
  end

  @spec delete(binary) :: {:ok, binary} | {:ok, binary}
  def delete(core) do
    case AdminCmd.run("delete -c #{core}") do
      {:ok, _} -> {:ok, "Deleted core '#{core}'"}
      {:error, _} -> {:error, "Failed to delete core '#{core}'"}
    end
  end

  @spec delete!(binary) :: :ok
  def delete!(core) do
    delete(core)
    :ok
  end

  @spec rename(binary, binary) :: :ok | {:error, binary}
  def rename(core, other) do
    query = [action: "RENAME", core: core, other: other]

    case Client.get("admin/cores", query: query) do
      {:ok, %Tesla.Env{status: 200, body: _}} -> :ok
      {:error, msg} -> {:error, msg}
    end
  end
end
