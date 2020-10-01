defmodule DgTest.Solr.FieldTest do
  use ExUnit.Case, async: true

  alias DgTest.Solr.Field

  @example_solr %{
    "name" => "name",
    "type" => "string",
    "stored" => false,
    "required" => false,
    "indexed" => true,
    "uninvertible" => false,
    "multiValued" => true
  }

  @example_field %Field{
    name: "name",
    type: "string",
    stored: false,
    indexed: true,
    required: false,
    uninvertible: false,
    multi_valued: true
  }

  describe "new" do
    test "new/1 returns a Field structure" do
      assert %Field{} = Field.new(%{})
    end

    test "new/1 maps solr format to field" do
      assert Field.new(@example_solr) == @example_field
    end
  end

  describe "from_list" do
    test "from_list/1 returns a list of Fields" do
      assert Field.from_list([@example_solr]) == [@example_field]
    end
  end

  describe "to_solr" do
    test "to_solr/1 return a Field map in Solr format" do
      assert Field.to_solr(@example_field) == @example_solr
    end
  end
end
