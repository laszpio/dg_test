defmodule DgTest.SolrTest do
  use ExUnit.Case, async: false

  alias DgTest.Solr

  describe "solr_timeout/0" do
    setup do
      original = Application.fetch_env!(:dg_test, :solr_timeout)
      on_exit(fn -> Application.put_env(:dg_test, :solr_timeout, original) end)
      :ok
    end

    test "returns 5000 when SOLR_TIMEOUT is unset (nil)" do
      Application.put_env(:dg_test, :solr_timeout, nil)
      assert Solr.solr_timeout() == 5000
    end

    test "parses a numeric string" do
      Application.put_env(:dg_test, :solr_timeout, "1234")
      assert Solr.solr_timeout() == 1234
    end

    test "returns 5000 when value isn't parseable" do
      Application.put_env(:dg_test, :solr_timeout, "not-a-number")
      assert Solr.solr_timeout() == 5000
    end
  end
end
