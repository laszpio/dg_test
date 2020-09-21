defmodule DgTest.Solr.CoresTest do
  use ExUnit.Case

  alias DgTest.Solr
  alias DgTest.Solr.Cores

  doctest DgTest.Solr.Cores

  describe "status" do
    test "status/0" do
      assert Cores.status == %{}
    end
  end
end
