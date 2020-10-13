defmodule DgTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      DgTest.Ghost.Client,
      DgTest.Solr.Client,
      DgTest.Solr.SchemaApi,
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DgTest.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
