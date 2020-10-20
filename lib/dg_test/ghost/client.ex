defmodule DgTest.Ghost.Client do
  use GenServer

  alias DgTest.Ghost

  def init(state) do
    {:ok, state}
  end

  def start_link(domain) do
    GenServer.start_link(__MODULE__, domain, name: process_name(domain))
  end

  def process_name(domain) do
    {:via, Registry, {Ghost.ClientRegistry, domain}}
  end

  def stop(pid) do
    GenServer.stop(pid, :normal)
  end

  def get!(path, query: query) do
    GenServer.call(__MODULE__, {:get!, path, query: query})
  end

  def handle_call({:get!, path, query: query}, _from, inital) do
    case Tesla.get!(client(), path, query: query) do
      %Tesla.Env{status: 200, body: body} -> {:reply, body, inital}
    end
  end

  def terminate(:normal, state) do
    state
  end

  def client do
    middleware = [
      {Tesla.Middleware.BaseUrl, ghost_api()},
      {Tesla.Middleware.Query, [key: ghost_key(), include: "authors,tags"]},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Logger, log_level: :info}
    ]

    Tesla.client(middleware)
  end

  defdelegate ghost_api, to: Ghost, as: :ghost_api

  defdelegate ghost_key, to: Ghost, as: :ghost_key
end
