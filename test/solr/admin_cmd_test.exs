defmodule DgTest.Solr.AdminCmdTest do
  use ExUnit.Case, async: true

  import Mock
  import DgTest.Solr.AdminCmd

  describe "run/1" do
    test "run/1 with empty command" do
      assert run("") == :error
    end

    test "run/1 create" do
    end

    test "run/1 delete" do
    end
  end


  describe "solr_cmd" do
    test "solr_cmd/0 return command string" do
      with_mock Application,
        fetch_env!: fn :dg_test, :solr_cmd -> "runner args solr" end do
        assert solr_cmd() == "runner args solr"
        assert called(Application.fetch_env!(:dg_test, :solr_cmd))
      end
    end
  end
end
