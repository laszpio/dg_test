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

  @schema_ok_response %{
    "responseHeader" => %{
      "status" => 0
    }
  }

  @schema_fail_response %{
    "error" => %{
      "details" => []
    }
  }

  setup do
    mock(fn
      %{method: :get, url: @schema_api} ->
        %Tesla.Env{status: 200, body: @schema_info}

      %{method: :get, url: @nocore_api} ->
        %Tesla.Env{status: 404, body: ""}

      %{method: :post, url: @schema_api} ->
        %Tesla.Env{status: 200, body: @schema_ok_response}
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

    test "add_field/3 when field already exist" do
      assert Schema.add_field("test", "test_field", "string") == :ok

      mock(fn %{method: :post, url: @schema_api} ->
          %Tesla.Env{status: 400, body: @schema_fail_response}
      end)

      assert Schema.add_field("test", "test_field", "string") == {:error, []}
    end
  end
end
