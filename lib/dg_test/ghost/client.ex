defmodule DgTest.Ghost.Client do
  use GenServer

  def init(client) do
    {:ok, client}
  end

  def start_link(client) do
    GenServer.start_link(__MODULE__, client, name: __MODULE__)
  end

  def get!(path, query: query) do
    GenServer.call(__MODULE__, {:get!, path, query: query})
  end

  def handle_call({:get!, path, query: query}, _from, client) do
    case Tesla.get!(client, path, query: query) do
      %Tesla.Env{status: 200, body: body} -> {:reply, body, client}
    end
  end
end
