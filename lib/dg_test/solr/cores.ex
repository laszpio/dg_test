defmodule DgTest.Solr.Cores do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "#{DgTest.solr_url()}/admin"
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Logger, log_level: :info

  def status do
    get("/cores", action: "STATUS")
  end

  def status(name) do
  end
end
