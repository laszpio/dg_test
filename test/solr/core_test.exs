defmodule DgTest.Solr.CoreTest do
  use ExUnit.Case, async: false

  import Mock

  alias DgTest.Solr.Core
  alias DgTest.Solr.Cmd

  def prepare_solr do
    Core.create("core_1")
    Core.create("core_2")

    :ok
  end

  def cleanup_solr do
    Core.delete("core_1")
    Core.delete("core_2")
    Core.delete("org_core")
    Core.delete("org_core_new")

    :ok
  end

  setup_all do
    prepare_solr()

    on_exit(fn -> cleanup_solr() end)
  end

  describe "status" do
    test "status/0 returns status for all cores" do
      assert {:ok, status} = Core.status()
      assert status["core_1"]
      assert status["core_2"]
    end

    test "status/1 returns core status" do
      assert {:ok, %{"core_1" => status}} = Core.status("core_1")
      assert status["name"] == "core_1"

      assert Map.keys(status) == [
               "config",
               "dataDir",
               "index",
               "instanceDir",
               "name",
               "schema",
               "startTime",
               "uptime"
             ]
    end

    test "status/1 returns error when core doesn't exist" do
      assert Core.status("nocore") == {:error, "Core 'nocore' doesn't exist."}
    end
  end

  describe "cores" do
    test "cores/0 returns list of cores" do
      cores = Core.cores()

      assert "core_1" in cores
      assert "core_2" in cores
    end
  end

  describe "exists?" do
    test "exists?/1 returns true when core exists" do
      assert Core.exists?("core_1")
      assert Core.exists?("core_2")
    end

    test "exists?/1 returns false when core doesn't exist" do
      refute Core.exists?("no_core")
    end
  end

  describe "ping" do
    test "ping/1 returns :ok when core is avalible" do
      assert Core.ping("core_1") == :ok
      assert Core.ping("core_2") == :ok
    end

    test "ping/1 returns :error when core doesn't exist" do
      assert Core.ping("nocore") == :error
    end
  end

  describe "create" do
    test "create/1 creates new core using command interface" do
      with_mock Cmd,
        run: fn "create -c test" -> {:ok, ""} end do
        assert Core.create("test") == {:ok, "Created new core 'test'"}
        assert called(Cmd.run("create -c test"))
      end
    end
  end

  describe "delete" do
    test "delete/1 removes a core using command interface" do
      with_mock Cmd,
        run: fn "delete -c test" -> {:ok, ""} end do
        assert Core.delete("test") == {:ok, "Deleted core 'test'"}
        assert called(Cmd.run("delete -c test"))
      end
    end
  end

  describe "rename" do
    setup do
      Core.create("org_core")

      on_exit(fn ->
        Core.delete("org_core")
        Core.delete("org_core_new")
      end)

      :ok
    end

    test "rename/2 renames a core" do
      assert Core.exists?("org_core")
      refute Core.exists?("org_core_new")

      assert Core.rename("org_core", "org_core_new")
      assert Core.exists?("org_core_new")
      refute Core.exists?("org_core")
    end
  end
end
