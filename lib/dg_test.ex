defmodule DgTest do
  @moduledoc """
  Documentation for `DgTest`.
  """

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
