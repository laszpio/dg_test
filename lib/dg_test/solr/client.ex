defmodule DgTest.Solr.Client do
  use GenServer

  alias DgTest.Solr

  def init(state) do
    {:ok, state}
  end

  def start_link(state \\ nil) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def stop(pid) do
    GenServer.stop(pid, :normal)
  end

  def get(path, query \\ []) do
    GenServer.call(__MODULE__, {:get, path, query})
  end

  def get!(path, query \\ []) do
    GenServer.call(__MODULE__, {:get!, path, query})
  end

  def handle_call({:get, path, query}, _from, state) do
    {:reply, Tesla.get(client(), path, query), state}
  end

  def handle_call({:get!, path, query}, _from, state) do
    case Tesla.get!(client(), path, query) do
      %Tesla.Env{} = response -> {:reply, response, state}
    end
  end

  @spec client() :: %Tesla.Client{}
  def client() do
    Tesla.client(middleware())
  end

  @spec middleware() :: list(tuple)
  def middleware() do
    [
      {Tesla.Middleware.BaseUrl, Solr.solr_url()},
      {Tesla.Middleware.JSON, decode_content_types: ["text/plain"]},
      {Tesla.Middleware.Logger, log_level: :info}
    ]
  end
end