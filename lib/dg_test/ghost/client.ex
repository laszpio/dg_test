defmodule DgTest.Ghost.Client do
  def get!(client, path, query: query) do
    case Tesla.get!(client, path, query: query) do
      %Tesla.Env{status: 200, body: body} -> body
    end
  end
end
