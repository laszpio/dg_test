defmodule DgTest.Solr.AdminCmd do
  @moduledoc false

  def exec(cmd) do
  end

  def solr_cmd_base do
    [cmd_base, _] = solr_cmd |> String.split()
  end

  def solr_cmd_opts do
    [_, cmd_opts] = solr_cmd |> String.split()
  end

  def solr_cmd do
    DgTest.solr_cmd()
  end
end
