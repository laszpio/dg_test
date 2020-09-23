defmodule DgTest.Solr.SchemaTest do
  use ExUnit.Case, async: true

  import Mock
  import Tesla.Mock

  alias DgTest.Solr.Schema

  doctest DgTest.Solr.Schema

  @nocore_api "http://localhost:8983/solr/nocore/schema"

  @schema_api "http://localhost:8983/solr/test/schema"

  @schema_info %{
    "schema" => %{
      "copyFields" => [],
      "dynamicFields" => [],
      "fields" => []
    }
  }

  setup do
    mock(fn
      %{method: :get, url: @schema_api} ->
        %Tesla.Env{status: 200, body: @schema_info}

      %{method: :get, url: @nocore_api} ->
        %Tesla.Env{status: 404, body: ""}

    end)

    :ok
  end

  describe "info" do
    test "info/1" do
      assert Schema.info("test") == @schema_info
    end

    test "info/1 when core doesn't exist" do
      assert Schema.info("nocore") == {:error, "Core 'nocore' doesn't exist."}
    end
  end
end
