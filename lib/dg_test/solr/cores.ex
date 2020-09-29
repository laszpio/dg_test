defmodule DgTest.Solr.Cores do
  use Tesla, only: [:get]

  alias DgTest.Solr.AdminApi

  @spec status() :: {:ok, map} | {:error, binary}
  def status do
    case get(AdminApi.client(), "/cores", query: [action: "STATUS"]) do
      {:ok, %Tesla.Env{status: 200, body: body}} -> parse_status(body)
      {:error, msg} -> {:error, msg}
    end
  end

  @spec status(binary | atom) :: {:ok, map} | {:error, binary}
  def status(core) do
    case get(AdminApi.client(), "/cores", query: [action: "STATUS", core: core]) do
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

  def create(core) do
    case System.cmd("solr", ["create", "-c", core], stderr_to_stdout: true) do
      {_, 0} -> {:ok, "Created new core '#{core}'"}
      {_, 1} -> {:error, "Core '#{core}' already exists"}
    end
  end

  def create!(core) do
    create(core)
    :ok
  end

  def delete(core) do
    case System.cmd("solr", ["delete", "-c", core], stderr_to_stdout: true) do
      {_, 0} -> {:ok, "Deleted core '#{core}'"}
      {_, 1} -> {:error, "Failed to delete core '#{core}'"}
    end
  end

  def delete!(core) do
    delete(core)
    :ok
  end

  def rename(core, other) do
    query = [action: "RENAME", core: core, other: other]

    case get(AdminApi.client(), "/cores", query: query) do
      {:ok, %Tesla.Env{status: 200, body: _}} -> :ok
      {:error, msg} -> {:error, msg}
    end
  end
end
