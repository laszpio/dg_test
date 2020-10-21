defmodule DgTest.Ghost.Client do
  use GenServer

  alias DgTest.Ghost.ClientRegistry

  def init(state) do
    {:ok, state}
  end

  def start_link({domain, api_url, api_key}) do
    GenServer.start_link(__MODULE__, client(api_url, api_key), name: process_name(domain))
  end

  def process_name(domain) do
    {:via, Registry, {ClientRegistry, domain}}
  end

  def stop(pid) do
    GenServer.stop(pid, :normal)
  end

  def get!(domain, path, query: query) do
    case Registry.lookup(ClientRegistry, domain) do
      [{pid, _}] -> pid
      _ -> nil
    end
    |> GenServer.call({:get!, path, query: query})
  end

  def handle_call({:get!, path, query: query}, _from, client) do
    case Tesla.get!(client, path, query: query) do
      %Tesla.Env{status: 200, body: body} -> {:reply, body, client}
    end
  end

  def terminate(:normal, state) do
    state
  end

  def client(api, key) do
    middleware = [
      {Tesla.Middleware.BaseUrl, api},
      {Tesla.Middleware.Query, [key: key, include: "authors,tags"]},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Logger, log_level: :info}
    ]

    Tesla.client(middleware)
  end
end
