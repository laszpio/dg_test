defmodule DgTest.Solr.AdminCmd do
  @moduledoc false

  @cmd_opts [stderr_to_stdout: true]

  def run(cmd) do
    [base | opts] = System.get_env("SOLR_CMD") |> String.split()

    case Kernel.apply(System, :cmd, [base, opts ++ String.split(cmd), @cmd_opts]) do
      {output, 0} -> {:ok, output}
      {output, 1} -> {:error, output}
    end
  end
end
