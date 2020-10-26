defmodule DgTest.Ghost.ClientTest do
  use ExUnit.Case, async: true

  import Mock

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
      assert {:ok, pid} = start_supervised({Client, {@domain, @api_url, @api_key}})
      assert %Tesla.Client{pre: @middleware} = :sys.get_state(pid)
    end

    test "registers started client process" do
      assert {:ok, pid} = start_supervised({Client, {@domain, @api_url, @api_key}})
      assert Registry.lookup(ClientRegistry, @domain) == [{pid, nil}]
    end
  end

  describe "stop/1" do
    test "stops and unregisters client" do
      assert {:ok, pid} = start_supervised({Client, {@domain, @api_url, @api_key}})
      assert Registry.lookup(ClientRegistry, @domain) == [{pid, nil}]

      assert Client.stop(pid)

      refute Process.alive?(pid)
      assert Registry.lookup(ClientRegistry, @domain) == []
    end
  end

  describe "get!/2" do
    test "performs API query" do
      assert {:ok, _pid} = start_supervised({Client, {@domain, @api_url, @api_key}})

      with_mock Tesla,
        get!: fn(_domain, _path, query: [])-> %Tesla.Env{status: 200, body: {}} end
      do
        assert Client.get!(@domain, "/pages/") == {}
      end
    end
  end

  describe "get!/3" do
    test "performs API query to path without params" do
      assert {:ok, _pid} = start_supervised({Client, {@domain, @api_url, @api_key}})

      with_mock Tesla,
        get!: fn(_client, _path, query: _query)-> %Tesla.Env{status: 200, body: {}} end
      do
        assert Client.get!(@domain, "/pages/", query: []) == {}
      end
    end
  end

  describe "client/2" do
    test "returns Tesla client" do
      client = Client.client(@api_url, @api_key)

      assert %Tesla.Client{pre: @middleware} = client
    end
  end
end
