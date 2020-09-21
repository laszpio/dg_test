defmodule DgTest.Solr.CoresTest do
  use ExUnit.Case, async: true

  import Mock

  alias DgTest.Solr
  alias DgTest.Solr.Cores

  doctest DgTest.Solr.Cores

  describe "status" do
    test "status/0 when no connection" do
      assert Cores.status == {:error, :econnrefused}
    end
  end

  describe "cores" do
  end

  describe "exists?" do
  end

  describe "create" do
    test "create/1 creates new core using command interface" do
      with_mock System, cmd: fn "solr", ["create", "-c", "test"] -> {"", 0} end do
        assert Cores.create("test") == {:ok, "Created new core 'test'"}
        assert called(System.cmd("solr", ["create", "-c", "test"]))
      end
    end
  end

  describe "delete" do
    test "delete/1 removes a core using command interface" do
      with_mock System, cmd: fn "solr", ["delete", "-c", "test"] -> {"", 0} end do
        assert Cores.delete("test") == {:ok, "Deleted core 'test'"}
        assert called(System.cmd("solr", ["delete", "-c", "test"]))
      end
    end
  end
end
