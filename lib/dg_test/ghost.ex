defmodule DgTest.Ghost do
  use Application

  def start(_type, _args) do
    children = [
      DgTest.Ghost.Client
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  @spec ghost_api :: binary
  def ghost_api do
    Application.fetch_env!(:dg_test, :ghost_api)
  end

  @spec ghost_key :: binary
  def ghost_key do
    Application.fetch_env!(:dg_test, :ghost_key)
  end
end
