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

  @schema_add_test_field %{
    "add-field" => %{
      name: "test",
      type: "string",
      stored: true
    }
  }

  setup do
    mock(fn
      %{method: :get, url: @schema_api} ->
        %Tesla.Env{status: 200, body: @schema_info}

      %{method: :get, url: @nocore_api} ->
        %Tesla.Env{status: 404, body: ""}

      %{method: :post, url: @schema_api, @schema_add_test_field} ->
        %Tesla.Env{status: 200, body: ""}
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

  describe "add_field" do
    test "add_field/3" do
      assert Schema.add_field("test", "test_field", "string") == :ok
    end
  end
end
