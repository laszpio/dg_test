defmodule DgTest.Ghost.ClientTest do
  use ExUnit.Case, async: true

  import Mock
  import DgTest.Ghost.Client

  @sample_api_url "http://localhost/ghost/api/v3/content"

  describe "ghost_url/0" do
    test "returns API url" do
      with_mock Application,
        fetch_env!: fn :dg_test, :ghost_url -> @sample_api_url end do
        assert ghost_url() == @sample_api_url
        assert called(Application.fetch_env!(:dg_test, :ghost_url))
      end
    end
  end

  describe "ghost_key/0" do
    test "returs API key" do
    end
  end
end