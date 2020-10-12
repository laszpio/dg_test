defmodule DgTest.Solr.SchemaApi do
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

  def info(core) do
    GenServer.call(__MODULE__, {:info, core})
  end

  def change(core, change) do
    GenServer.call(__MODULE__, {:change, core, change})
  end

  def handle_call({:info, core}, _from, state) do
    case Tesla.get!(client(), "/#{core}/schema") do
      %Tesla.Env{} = response -> {:reply, response, state}
    end
  end

  def handle_call({:change, core, change}, _from, state) do
    case Tesla.post!(client(), "/#{core}/schema", change) do
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