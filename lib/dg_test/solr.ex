defmodule DgTest.Solr do
  @moduledoc false

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
    case Application.fetch_env!(:dg_test, :solr_timeout) do
      nil ->
        5000

      timeout ->
        case Integer.parse(timeout) do
          {t, _} -> t
          :error -> 5000
        end
    end
  end
end
