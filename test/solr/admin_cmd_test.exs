defmodule DgTest.Solr.AdminCmdTest do
  use ExUnit.Case, async: true

  import Mock
  import DgTest.Solr.AdminCmd

  describe "solr_cmd" do
    test "solr_cmd/0 return command string" do
      with_mock Application,
        fetch_env!: fn :dg_test, :solr_cmd -> "solr args" end do
        assert solr_cmd() == "solr args"
      end
    end
  end
end
