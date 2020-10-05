defmodule DgTest.Solr.AdminCmdTest do
  use ExUnit.Case, async: false

  import Mock
  import DgTest.Solr.AdminCmd

  setup_with_mocks([
    {Application, [], [fetch_env!: fn :dg_test, :solr_cmd -> "runner args solr" end]}
  ]) do
    :ok
  end

  describe "solr_cmd/0" do
    test "solr_cmd/0 returns command string" do
      assert solr_cmd() == "runner args solr"
      assert called(Application.fetch_env!(:dg_test, :solr_cmd))
    end
  end

  describe "run/1" do
    test "create" do
      with_mock System,
        cmd: fn "runner", ~w(args solr create -c test), stderr_to_stdout: true ->
          {"output", 0}
        end do
        assert run("create -c test") == {:ok, "output"}

        assert called(
                 System.cmd(
                   "runner",
                   ~w(args solr create -c test),
                   stderr_to_stdout: true
                 )
               )
      end
    end

    test "delete" do
      with_mock System,
        cmd: fn "runner", ~w(args solr delete -c test), stderr_to_stdout: true ->
          {"output", 0}
        end do
        assert run("delete -c test") == {:ok, "output"}

        assert called(
                 System.cmd(
                   "runner",
                   ~w(args solr delete -c test),
                   stderr_to_stdout: true
                 )
               )
      end
    end
  end
end
