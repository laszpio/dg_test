defmodule DgTest.Solr.Client do
  use GenServer

  alias DgTest.Solr

  def init(state) do
    {:ok, state}
  end

  def start_link(domain) do
    GenServer.start_link(__MODULE__, domain, name: process_name(domain))
  end

  def process_name(domain) do
    {:via, Registry, {Ghost.ClientRegistry, "client_for_#{domain}"}}
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
    middleware = [
      {Tesla.Middleware.BaseUrl, solr_url()},
      {Tesla.Middleware.JSON, decode_content_types: ["text/plain"]},
      {Tesla.Middleware.Logger, log_level: :info}
    ]

    Tesla.client(middleware)
  end

  defdelegate solr_url, to: Solr, as: :solr_url
end
