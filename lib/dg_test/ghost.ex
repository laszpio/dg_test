defmodule DgTest.Ghost do
  use Application

  def start(_type, _args) do
    children = [
      DgTest.Ghost.Client
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
