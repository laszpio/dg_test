defmodule DgTest.Solr.SchemaTest do
  use ExUnit.Case, async: true

  alias DgTest.Solr.Schema
  alias DgTest.Solr.Cores

  def prepare_solr do
    case Cores.exists?("test") do
      false ->
        Cores.create("test")

      true ->
        Cores.delete("test")
        Cores.create("test")
    end
    :ok
  end

  def cleanup_solr do
    Cores.delete("test")
    :ok
  end

  setup_all do
    prepare_solr()
    on_exit(fn -> cleanup_solr() end)
    :ok
  end

  describe "info" do
    test "info/1" do
      assert {:ok, info} = Schema.info("test")

      assert Map.keys(info) == [
               "copyFields",
               "dynamicFields",
               "fieldTypes",
               "fields",
               "name",
               "uniqueKey",
               "version"
             ]
    end

    test "info/1 when core doesn't exist" do
      assert Schema.info("nocore") == {:error, "Core 'nocore' doesn't exist."}
    end
  end

  describe "add_field" do
    test "add_field/3 add nonexisting field" do
      assert Schema.add_field("test", "test_field_a", "string") == :ok
    end

    test "add_field/3 when field already exist" do
      assert Schema.add_field("test", "test_field_b", "string") == :ok

      assert Schema.add_field("test", "test_field_b", "string") ==
               {:error,
                [
                  %{
                    "add-field" => %{
                      "name" => "test_field_b",
                      "stored" => true,
                      "type" => "string"
                    },
                    "errorMessages" => ["Field 'test_field_b' already exists.\n"]
                  }
                ]}
    end
  end

  describe "remove_field" do
    test "remove_field/2 remove existing field" do
      assert Schema.add_field("test", "test_field_c", "string") == :ok
      assert Schema.remove_field("test", "test_field_c") == :ok
    end

    test "remove_field/2 field doesn't exist" do
      assert Schema.remove_field("test", "test_field_c") ==
               {:error,
                [
                  %{
                    "delete-field" => %{"name" => "test_field_c"},
                    "errorMessages" => [
                      "The field 'test_field_c' is not present in this schema, and so cannot be deleted.\n"
                    ]
                  }
                ]}
    end
  end

  describe "add_copy_field" do
    test "add_copy_field/3" do
      assert Schema.add_field("test", "test_field", "string") == :ok
      assert Schema.add_field("test", "test_other", "string") == :ok

      assert Schema.add_copy_field("test", "test_field", "test_other") == :ok
    end

    test "add_copy_field/3 fails when source field doesn't exist" do
      assert Schema.add_copy_field("test", "no_test_field", "test_other") ==
               {:error,
                [
                  %{
                    "add-copy-field" => %{
                      "source" => "no_test_field",
                      "dest" => "test_other"
                    },
                    "errorMessages" => [
                      "copyField source :'no_test_field' is not a glob and doesn't match any explicit field or dynamicField.\n"
                    ]
                  }
                ]}
    end
  end
end
