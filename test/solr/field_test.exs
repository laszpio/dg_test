defmodule DgTest.Solr.FieldTest do
  use ExUnit.Case, async: true

  alias DgTest.Solr.Field

  describe "new" do
    test "new/1 returns a Field structure" do
      assert %Field{} = Field.new(%{})
    end

    test "new/1 maps solr format to field" do
      solr = %{
        "name" => "name",
        "type" => "string",
        "indexed" => true,
        "multiValued" => true
      }

      assert Field.new(solr) == %Field{
               name: "name",
               type: "string",
               indexed: true,
               multi_valued: true
             }
    end
  end
end
