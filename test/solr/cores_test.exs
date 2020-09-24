defmodule DgTest.Solr.CoresTest do
  use ExUnit.Case, async: true

  import Mock

  alias DgTest.Solr.Cores

  def prepare_solr do
    Cores.create("core_1")
    Cores.create("core_2")

    :ok
  end

  def cleanup_solr do
    Cores.delete("core_1")
    Cores.delete("core_2")

    :ok
  end

  setup_all do
    prepare_solr()

    on_exit(fn -> cleanup_solr() end)
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

    test "status/1 returns error when core doesn't exist" do
      assert Cores.status("nocore") == {:error, "Core 'nocore' doesn't exist."}
    end
  end

  describe "cores" do
    test "cores/0 returns list of cores" do
      cores = Cores.cores()

      assert "core_1" in cores
      assert "core_2" in cores
    end
  end

  describe "exists?" do
    test "exists?/1 returns true when core exists" do
      assert Cores.exists?("core_1")
      assert Cores.exists?("core_2")
    end

    test "exists?/1 returns false when core doesn't exist" do
      refute Cores.exists?("no_core")
    end
  end

  describe "create" do
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
    setup do
      Cores.create("org_core")

      on_exit(fn ->
        Cores.delete("org_core")
        Cores.delete("org_core_new")
      end)

      :ok
    end

    test "rename/2 renames a core" do
      assert Cores.exists?("org_core")
      refute Cores.exists?("org_core_new")

      assert {:ok, _} = Cores.rename("org_core", "org_core_new")
      assert Cores.exists?("org_core_new")
      refute Cores.exists?("org_core")

      assert {:error, _} = Cores.delete("org_core")
      assert {:ok, _} = Cores.delete("org_core_new")
    end
  end
end
