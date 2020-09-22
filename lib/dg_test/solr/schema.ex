defmodule DgTest.Solr.Schema do
  use Tesla, only: [:get]

  def info(core) do
    case get!(client(), "/#{core}/schema/") do
      %Tesla.Env{status: 200, body: body} -> Jason.decode(body)
      %Tesla.Env{status: 404} -> {:error, "Core '#{core}' doesn't exist."}
    end
  end

  def client() do
    Tesla.client(middleware())
  end

  def middleware() do
    [
      {Tesla.Middleware.BaseUrl, DgTest.solr_url()},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Logger, log_level: :info}
    ]
  end
end
