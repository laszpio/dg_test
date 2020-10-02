defmodule DgTest.Solr.AdminCmd do
  @moduledoc false

  def solr_cmd(cmd) do
    [base | opts] = System.get_env("SOLR_CMD") |> String.split()

    {base, opts}
  end
end
