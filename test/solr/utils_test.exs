defmodule DgTest.Solr.UtilsTest do
  use ExUnit.Case, async: true

  alias DgTest.Solr.Utils

  describe "solarize" do
    test "solarize/1 converts attribute to Solar convention" do
      assert Utils.solarize(:attribute) == "attribute"
      assert Utils.solarize(:snake_case) == "snakeCase"
    end

    test "solarize/1 converts string attribute to Solar convention" do
      assert Utils.solarize("attribute") == "attribute"
      assert Utils.solarize("snake_case") == "snakeCase"
    end
  end
end
