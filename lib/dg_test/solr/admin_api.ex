defmodule DgTest.Solr.AdminApi do
  def client do
    Tesla.client(middleware())
  end

  def middleware do
    [
      {Tesla.Middleware.BaseUrl, "#{DgTest.solr_url()}/admin"},
      Tesla.Middleware.JSON
    ]
  end
end
