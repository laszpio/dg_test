defmodule DgTest do
  use Tesla

  plug Tesla.Middleware.BaseUrl, posts_url
  plug Tesla.Middleware.JSON

  def posts do
    get("")
  end

  @doc """
  Hello world.

  ## Examples

      iex> DgTest.posts_url()
      "https://ghost.local/api/v3/content/posts/?key=secret"

  """
  def posts_url do
    {:ok, url} = Application.fetch_env(:dg_test, :ghost_url)
    {:ok, auth} = Application.fetch_env(:dg_test, :ghost_key)

    "#{url}/posts/?key=#{auth}"
  end
end
