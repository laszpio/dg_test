defmodule DgTest.Solr.Schema do
  use Tesla, only: [:get, :post]

  def info(core) do
    case get!(client(), "/#{core}/schema") do
      %Tesla.Env{status: 200, body: body} -> body
      %Tesla.Env{status: 404} -> {:error, "Core '#{core}' doesn't exist."}
    end
  end

  def add_field(core, name, type) do
    data = %{
      "add-field" => %{
        name: name,
        type: type,
        stored: true
      }
    }

    case post!(client(), "/#{core}/schema", data) do
      %Tesla.Env{status: 200, body: body} -> parse_response(body)
      %Tesla.Env{status: 400, body: body} -> parse_response(body)
    end
  end

  def remove_field(core, name) do
    data = %{"delete-field" => %{"name" => name}}

    case post!(client(), "/#{core}/schema", data) do
      %Tesla.Env{status: 200, body: body} -> parse_response(body)
      %Tesla.Env{status: 400, body: body} -> parse_response(body)
    end
  end

  def add_copy_field(core, source, dest) do
    data = %{
      "add-copy-field" => %{
        source: source,
        dest: dest
      }
    }

    case post!(client(), "/#{core}/schema", data) do
      %Tesla.Env{status: 200, body: body} -> parse_response(body)
      %Tesla.Env{status: 400, body: body} -> parse_response(body)
    end
  end

  def remove_copy_field(core, source, dest) do
    data = %{
      "add-copy-field" => %{
        source: source,
        dest: dest
      }
    }

    case post!(client(), "/#{core}/schema", data) do
      %Tesla.Env{status: 200, body: body} -> parse_response(body)
      %Tesla.Env{status: 400, body: body} -> parse_response(body)
    end
  end

  def parse_response(%{"responseHeader" => %{"status" => 0}}) do
    :ok
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
      {Tesla.Middleware.JSON, decode_content_types: ["text/plain"]},
      {Tesla.Middleware.Logger, log_level: :info}
    ]
  end
end
