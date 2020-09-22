defmodule DgTest.Solr.AdminApiTest do
  use ExUnit.Case, async: true

  import DgTest.Solr.AdminApi

  test "client/0 returns a Tesla client" do
    assert %Tesla.Client{} = client()
  end
end
