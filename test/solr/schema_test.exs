defmodule DgTest.Solr.SchemaTest do
  use ExUnit.Case, async: true

  import Mock
  import Tesla.Mock

  alias DgTest.Solr.Schema

  doctest DgTest.Solr.Schema
end
