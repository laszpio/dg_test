defmodule DgTest.Solr.Cores do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "#{DgTest.solr_url()}/admin"
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Logger, log_level: :info

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
end
