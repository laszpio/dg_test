defmodule DgTest.Ghost.Client do
  use GenServer

  def init(init_args) do
    {:ok, init_args}
  end

  def start_link(inital \\ nil) do
    GenServer.start_link(__MODULE__, inital, name: __MODULE__)
  end

  def get!(path, query: query) do
    GenServer.call(__MODULE__, {:get!, path, query: query})
  end

  def handle_call({:get!, path, query: query}, _from, inital) do
    case Tesla.get!(client(), path, query: query) do
      %Tesla.Env{status: 200, body: body} -> {:reply, body, inital}
    end
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

  @spec ghost_url :: binary
  def ghost_url do
    Application.fetch_env!(:dg_test, :ghost_url)
  end

  @spec ghost_key :: binary
  def ghost_key do
    Application.fetch_env!(:dg_test, :ghost_key)
  end
end
