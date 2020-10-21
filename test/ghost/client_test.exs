defmodule DgTest.Ghost.ClientTest do
  use ExUnit.Case, async: true

  alias DgTest.Ghost.Client

  @api_url "http://localhost/ghost/api/v3/content"
  @api_key "token"

  describe "start_link/1" do
    test "starts authenticated client process" do
      assert {:ok, pid} = Client.start_link({"http://localhost", @api_url, @api_key})
    end
  end

  describe "client/2" do
    test "returns Tesla client" do
      client = Client.client(@api_url, @api_key)

      assert %Tesla.Client{} = client

      assert {Tesla.Middleware.BaseUrl, :call, [@api_url]} in client.pre
      assert {Tesla.Middleware.Query, :call, [[key: @api_key, include: "authors,tags"]]} in client.pre
      assert {Tesla.Middleware.JSON, :call, [[]]} in client.pre
      assert {Tesla.Middleware.Logger, :call, [[log_level: :info]]} in client.pre
    end
  end
end
