defmodule DgTest.Solr.AdminApi do
  @moduledoc false

  def client do
    Tesla.client(middleware())
  end

  def middleware do
    [
      {Tesla.Middleware.BaseUrl, "#{DgTest.solr_url()}/admin"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Logger, log_level: :info}
    ]
  end
end
