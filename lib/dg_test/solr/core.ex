defmodule DgTest.Solr.Core do
  import DgTest.Solr.Utils

  defstruct [
    :name,
    :schema,
    :start_time,
    :uptime,
    :index,
    :dataDir
  ]
end
