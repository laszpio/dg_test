defmodule DgTest.Solr.CoresTest do
  use ExUnit.Case, async: true

  import Mock
  import Tesla.Mock

  alias DgTest.Solr.Cores

  doctest DgTest.Solr.Cores

  @solr_url "http://localhost:8983/solr/admin/cores"

  @status %{
    "status" => %{
      "core_1" => %{"name" => "core_1"},
      "core_2" => %{"name" => "core_2"},
      "core_3" => %{"name" => "core_3"}
    }
  }

  @status_core_1 %{"status" => %{"name" => "core_1"}}

  @status_nocore %{"status" => %{"nocore" => %{}}}

  setup do
    mock(fn
      %{method: :get, url: @solr_url, query: [action: "STATUS"]} ->
        %Tesla.Env{status: 200, body: @status}

      %{method: :get, url: @solr_url, query: [action: "STATUS", core: "core_1"]} ->
        %Tesla.Env{status: 200, body: @status_core_1}

      %{method: :get, url: @solr_url, query: [action: "STATUS", core: "nocore"]} ->
        %Tesla.Env{status: 200, body: @status_nocore}

      %{
        method: :get,
        url: @solr_url,
        query: [action: "RENAME", core: "test_rename_a", other: "test_rename_b"]
      } ->
        %Tesla.Env{status: 200, body: @status_core_1}
    end)

    :ok
  end

  describe "status" do
    test "status/0 returns status for all cores" do
      assert Cores.status() ==
               {:ok,
                %{
                  "core_1" => %{"name" => "core_1"},
                  "core_2" => %{"name" => "core_2"},
                  "core_3" => %{"name" => "core_3"}
                }}
    end

    test "status/1 returns core status" do
      assert Cores.status("core_1") == {:ok, %{"name" => "core_1"}}
    end

    test "status/1 returns error when core doesn't exist" do
      assert Cores.status("nocore") == {:error, "Core 'nocore' doesn't exist."}
    end
  end

  describe "cores" do
    test "cores/0 returns list of cores" do
      assert Cores.cores() == ["core_1", "core_2", "core_3"]
    end
  end

  describe "exists?" do
    test "exists?/1 returns true when core exists" do
      assert Cores.exists?("core_1")
      assert Cores.exists?("core_2")
      assert Cores.exists?("core_3")
    end

    test "exists?/1 returns false when core doesn't exist" do
      refute Cores.exists?("no_core")
    end
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

  describe "rename" do
    test "rename/2 renames a core" do
      assert {:ok, _} = Cores.rename("test_rename_a", "test_rename_b")
    end
  end
end
