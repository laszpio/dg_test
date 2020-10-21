defmodule DgTest.Ghost.ClientTest do
  use ExUnit.Case, async: true

  alias DgTest.Ghost.Client

  @api_url "http://localhost/ghost/api/v3/content"
  @api_key "token"

  describe "client" do
    test "returns Tesla client" do
      client = Client.client(@api_url, @api_key)

      assert %Tesla.client{} = client
    end
  end
end
