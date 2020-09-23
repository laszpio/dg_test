defmodule DgTest.Solr.Schema do
  use Tesla, only: [:get, :post]

  def info(core) do
    case get!(client(), "/#{core}/schema/") do
      %Tesla.Env{status: 200, body: body} -> Jason.decode(body)
      %Tesla.Env{status: 404} -> {:error, "Core '#{core}' doesn't exist."}
    end
  end

  def add_field(core, name) do
    data = %{
      "add-field" => %{
        name: name,
        type: "pdate",
        stored: true
      }
    }

    case post!(client(), "/#{core}/schema", data) do
      %Tesla.Env{status: 200, body: body} -> Jason.decode!(body) |> parse_response()
      %Tesla.Env{status: 400, body: body} -> Jason.decode!(body) |> parse_response()
    end
  end

  def parse_response(%{"responseHeader" => %{"status" => 0}}) do
    {:ok, "Field added."}
  end

  def parse_response(%{"error" => %{"details" => details}}) do
    {:error, details}
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
