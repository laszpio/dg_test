defmodule DgTest.Solr.SchemaApi do
  alias DgTest.Solr

  @spec client() :: %Tesla.Client{}
  def client() do
    Tesla.client(middleware())
  end

  @spec middleware() :: list(tuple)
  def middleware() do
    [
      {Tesla.Middleware.BaseUrl, Solr.solr_url()},
      {Tesla.Middleware.JSON, decode_content_types: ["text/plain"]},
      {Tesla.Middleware.Logger, log_level: :info}
    ]
  end
end