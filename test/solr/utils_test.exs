defmodule DgTest.Solr.UtilsTest do
  use ExUnit.Case, async: true

  alias DgTest.Solr.Utils

  describe "to_struct" do
    defmodule TestStruct do
      defstruct [:attr]
    end

    test "to_struct/2 maps to structure" do
      Utils.to_struct(%TestStruct{}, %{attr: "A"}) == %TestStruct{attr: "A"}
    end
  end

  describe "solarize" do
    test "solarize/1 converts attribute to Solar convention" do
      assert Utils.solarize(:attribute) == "attribute"
      assert Utils.solarize(:snake_case) == "snakeCase"
    end

    test "solarize/1 converts string attribute to Solar convention" do
      assert Utils.solarize("attribute") == "attribute"
      assert Utils.solarize("snake_case") == "snakeCase"
    end

    test "solarize/1 converts map to Solr convention" do
      test_map = %{
        :attribute => false,
        :snake_case => false
      }

      assert Utils.solarize(test_map) == %{
               "attribute" => false,
               "snakeCase" => false
             }
    end

    test "solarize/1 strings" do
      assert Utils.solarize("") == ""

      assert Utils.solarize("a") == "a"
      assert Utils.solarize("A") == "a"

      assert Utils.solarize("AaBb") == "aaBb"
      assert Utils.solarize("aaBb") == "aaBb"

      assert Utils.solarize("a_b") == "aB"
    end

    test "solarize/1 atoms" do
      assert Utils.solarize(:"") == ""

      assert Utils.solarize(:a) == "a"
      assert Utils.solarize(:A) == "a"

      assert Utils.solarize(:AaBb) == "aaBb"
      assert Utils.solarize(:aaBb) == "aaBb"

      assert Utils.solarize(:a_b) == "aB"
    end
  end
end
