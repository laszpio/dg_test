defmodule DgTest.Solr.CoresTest do
  use ExUnit.Case, async: true

  import Mock

  alias DgTest.Solr.Cores

  def prepare_solr do
    Cores.create("core_1")
    Cores.create("core_2")

    :ok
  end

  setup_all do
    prepare_solr()
  end

  describe "status" do
    test "status/0 returns status for all cores" do
      assert {:ok, status} = Cores.status()
      assert status["core_1"]
      assert status["core_2"]
    end

    test "status/1 returns core status" do
      assert {:ok, %{"core_1" => status}} = Cores.status("core_1")
      assert status["name"] == "core_1"
      assert Map.keys(status) == ["config", "dataDir", "index", "instanceDir", "name", "schema", "startTime", "uptime"]
    end

    @tag :skip
    test "status/1 returns error when core doesn't exist" do
      assert Cores.status("nocore") == {:error, "Core 'nocore' doesn't exist."}
    end
  end

  describe "cores" do
    @tag :skip
    test "cores/0 returns list of cores" do
      assert Cores.cores() == ["core_1", "core_2", "core_3"]
    end
  end

  describe "exists?" do
    @tag :skip
    test "exists?/1 returns true when core exists" do
      assert Cores.exists?("core_1")
      assert Cores.exists?("core_2")
      assert Cores.exists?("core_3")
    end

    @tag :skip
    test "exists?/1 returns false when core doesn't exist" do
      refute Cores.exists?("no_core")
    end
  end

  describe "create" do
    @tag :skip
    test "create/1 creates new core using command interface" do
      with_mock System,
        cmd: fn "solr", ["create", "-c", "test"], stderr_to_stdout: true -> {"", 0} end do
        assert Cores.create("test") == {:ok, "Created new core 'test'"}
        assert called(System.cmd("solr", ["create", "-c", "test"], stderr_to_stdout: true))
      end
    end
  end

  describe "delete" do
    test "delete/1 removes a core using command interface" do
      with_mock System,
        cmd: fn "solr", ["delete", "-c", "test"], stderr_to_stdout: true -> {"", 0} end do
        assert Cores.delete("test") == {:ok, "Deleted core 'test'"}
        assert called(System.cmd("solr", ["delete", "-c", "test"], stderr_to_stdout: true))
      end
    end
  end

  describe "rename" do
    @tag :skip
    test "rename/2 renames a core" do
      assert {:ok, _} = Cores.rename("test_rename_a", "test_rename_b")
    end
  end
end
