defmodule DgTest.Ghost do
  @moduledoc false

  @spec ghost_url :: binary
  def ghost_url do
    Application.fetch_env!(:dg_test, :ghost_url)
  end

  @spec ghost_key :: binary
  def ghost_key do
    Application.fetch_env!(:dg_test, :ghost_key)
  end
end
