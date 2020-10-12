defmodule DgTest.Solr do
  use Application

  def start(_type, _args) do
    children = [
      {DgTest.Solr.SchemaApi, []}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  @spec solr_url() :: binary
  def solr_url do
    Application.fetch_env!(:dg_test, :solr_url)
  end

  @spec solr_core() :: binary
  def solr_core do
    Application.fetch_env!(:dg_test, :solr_core)
  end

  @spec target_url() :: binary
  def target_url do
    solr_url() <> "/" <> solr_core()
  end
end
