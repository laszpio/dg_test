defmodule DgTest.Solr.Schema do
  use Tesla, only: [:get, :post]

  def info(core) do
    case get!(client(), "/solr/#{core}/schema/") do
      %Tesla.Env{status: 200, body: body} -> Jason.decode(body)
      %Tesla.Env{status: 404} -> {:error, "Core '#{core}' doesn't exist."}
    end
  end

  def add_field(core, name) do
    path = "/api/collections/#{core}/schema"
    data = %{"add-field" => %{name: "created_at", type: "pdate", stored: true}}

    case post!(client(), path, data) do
      %Tesla.Env{status: 200, body: body} -> body
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
