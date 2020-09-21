defmodule DgTest.Solr.Cores do
  use Tesla, only: [:get]

  plug(Tesla.Middleware.BaseUrl, "#{DgTest.solr_url()}/admin")
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.Logger, log_level: :info)

  def status do
    case get("/cores", action: "STATUS") do
      {:ok, %{status: 200, body: body}} -> {:ok, body}
      {:error, msg} -> {:error, msg}
    end
  end

  def status(core) do
    case get("/cores", action: "STATUS", core: core) do
      {:ok, %{status: 200, body: body}} -> {:ok, body}
      {:error, msg} -> {:error, msg}
    end
  end

  def cores do
    {:ok, %{"status" => status}} = status()
    Map.keys(status)
  end

  def exists?(core), do: core in cores()

  def create(core) do
    case System.cmd("solr", ["create", "-c", core]) do
      {_, 0} -> {:ok, "Created new core '#{core}'"}
      {_, 1} -> {:error, "Core '#{core}' already exists"}
    end
  end

  def delete(core) do
    case System.cmd("solr", ["delete", "-c", core]) do
      {_, 0} -> {:ok, "Deleted core '#{core}'"}
      {_, 1} -> {:error, "Failed to delete core '#{core}'"}
    end
  end
end
