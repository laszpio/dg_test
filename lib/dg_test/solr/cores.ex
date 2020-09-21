defmodule DgTest.Solr.Cores do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "#{DgTest.solr_url()}/admin"
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Logger, log_level: :info

  def status do
    case get("/cores", action: "STATUS") do
      {:error, msg} -> {:error, msg}
      {:ok, resp} -> resp
    end
  end
end
