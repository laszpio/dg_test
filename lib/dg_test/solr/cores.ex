defmodule DgTest.Solr.Cores do
  use Tesla

  @base_url "#{DgTest.solr_url()}/admin/cores"

  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Logger, log_level: :info

  def status do
    get(@base_url, action: "STATUS")
  end

  def status(name) do
  end
end
