defmodule DgTest.Solr.AdminCmd do
  use GenServer

  def init(state) do
    {:ok, state}
  end

  def start_link(state \\ nil) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @cmd_opts [stderr_to_stdout: true]

  @spec run(binary) :: {:ok, binary} | {:error, binary}
  def run(cmd) do
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
