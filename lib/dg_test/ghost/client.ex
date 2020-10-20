defmodule DgTest.Ghost.Client do
  use GenServer

  alias DgTest.Ghost

  def init(state) do
    {:ok, state}
  end

  def start_link(state \\ nil) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
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
      {Tesla.Middleware.BaseUrl, ghost_url()},
      {Tesla.Middleware.Query, [key: ghost_key(), include: "authors,tags"]},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Logger, log_level: :info}
    ]

    Tesla.client(middleware)
  end

  defdelegate ghost_url, to: Ghost, as: :ghost_url

  defdelegate ghost_key, to: Ghost, as: :ghost_key
end
