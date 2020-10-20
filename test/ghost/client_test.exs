defmodule DgTest.Ghost.ClientTest do
  use ExUnit.Case, async: true

  import Mock
  import DgTest.Ghost.Client

  @api_url "http://localhost/ghost/api/v3/content"
  @api_key "token"

  describe "ghost_api/0" do
    test "returns API url" do
      with_mock Application,
        fetch_env!: fn :dg_test, :ghost_api -> @api_url end do
        assert ghost_api() == @api_url
        assert called(Application.fetch_env!(:dg_test, :ghost_api))
      end
    end
  end

  describe "ghost_key/0" do
    test "returs API key" do
      with_mock Application,
        fetch_env!: fn :dg_test, :ghost_key -> @api_key end do
        assert ghost_key() == @api_key
        assert called(Application.fetch_env!(:dg_test, :ghost_key))
      end
    end
  end
end
