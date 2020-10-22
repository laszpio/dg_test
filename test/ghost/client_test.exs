defmodule DgTest.Ghost.ClientTest do
  use ExUnit.Case, async: true

  alias DgTest.Ghost.Client
  alias DgTest.Ghost.ClientRegistry

  @domain "http://localhost"
  @api_url "http://localhost/ghost/api/v3/content"
  @api_key "token"

  @middleware [
    {Tesla.Middleware.BaseUrl, :call, [@api_url]},
    {Tesla.Middleware.Query, :call, [[key: @api_key, include: "authors,tags"]]},
    {Tesla.Middleware.JSON, :call, [[]]},
    {Tesla.Middleware.Logger, :call, [[log_level: :info]]}
  ]

  describe "start_link/1" do
    test "client process with credentials" do
      assert {:ok, pid} = Client.start_link({@domain, @api_url, @api_key})
      assert %Tesla.Client{pre: @middleware} = :sys.get_state(pid)
    end

    test "registers started client process" do
      assert {:ok, pid} = Client.start_link({@domain, @api_url, @api_key})
      assert [{reg, _}] = Registry.lookup(ClientRegistry, @domain)
      assert pid == reg
    end
  end

  describe "stop/1" do
    test "stops and unregisters client" do
      assert {:ok, pid} = Client.start_link({@domain, @api_url, @api_key})
      assert {:ok, _} = Client.start_link({"other", @api_url, @api_key})

      assert Registry.lookup(ClientRegistry, @domain) |> Enum.count() == 1
      assert Registry.lookup(ClientRegistry, "other") |> Enum.count() == 1
      assert Registry.count(ClientRegistry) == 2

      Client.stop(pid)

      assert Registry.count(ClientRegistry) == 1
      assert Registry.lookup(ClientRegistry, "other") |> Enum.count() == 1
      assert Registry.lookup(ClientRegistry, @domain) |> Enum.count() == 0
    end
  end

  describe "client/2" do
    test "returns Tesla client" do
      client = Client.client(@api_url, @api_key)

      assert %Tesla.Client{pre: @middleware} = client
    end
  end
end
