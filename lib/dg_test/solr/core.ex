defmodule DgTest.Solr.Core do
  @moduledoc false

  defstruct [
    :name,
    :schema,
    :start_time,
    :uptime,
    :index,
    :dataDir
  ]
end
