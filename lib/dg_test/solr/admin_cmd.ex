defmodule DgTest.Solr.AdminCmd do
  @moduledoc false

  @cmd_opts [stderr_to_stdout: true]

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
