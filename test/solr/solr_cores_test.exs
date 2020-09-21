defmodule DgTest.Solr.CoresTest do
  use ExUnit.Case

  import Tesla.Mock

  alias DgTest.Solr
  alias DgTest.Solr.Cores

  doctest DgTest.Solr.Cores

  describe "status" do
    test "status/0 when no connection" do
      assert Cores.status == {:error, :econnrefused}
    end
  end
end
