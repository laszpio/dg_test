defmodule DgTest.Solr.AdminCmd do
  use GenServer

  @cmd_opts [stderr_to_stdout: true]

  def init(state) do
    {:ok, state}
  end

  def start_link(state \\ nil) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def run(cmd) do
    GenServer.call(__MODULE__, {:run, cmd})
  end

  def handle_call({:run, cmd}, _from, state) do
    {:reply, do_run(cmd), state}
  end

  @spec do_run(binary) :: {:ok, binary} | {:error, binary}
  def do_run(cmd) do
    [base | opts] = solr_cmd() |> String.split()

    case Kernel.apply(System, :cmd, [base, opts ++ String.split(cmd), @cmd_opts]) do
      {output, 0} -> {:ok, output}
      {output, 1} -> {:error, output}
    end
  end

  def solr_cmd do
    Application.fetch_env!(:dg_test, :solr_cmd)
  end
end
