defmodule DgTest.Solr do
  use Application

  def start(_type, _args) do
    children = [
      {DgTest.Solr.Client, []},
      {DfTest.Solr.Cmd, []},
      {DgTest.Solr.SchemaApi, []}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  @spec solr_url() :: binary
  def solr_url, do: Application.fetch_env!(:dg_test, :solr_url)

  @spec solr_core() :: binary
  def solr_core, do: Application.fetch_env!(:dg_test, :solr_core)

  @spec target_url() :: binary
  def target_url, do: solr_url() <> "/" <> solr_core()

  @spec solr_cmd() :: binary
  def solr_cmd, do: Application.fetch_env!(:dg_test, :solr_cmd)

  @spec solr_timeout() :: pos_integer
  def solr_timeout do
    timeout = Application.fetch_env!(:dg_test, :solr_timeout)

    case Integer.parse(timeout) do
      {t, _} -> t
      :error -> 5000
    end
  end
end
