defmodule DgTest.MixProject do
  use Mix.Project

  def project do
    [
      app: :dg_test,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {DgTest.Application, []},
      extra_applications: [:logger, :hackney]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.3.0"},
      {:hackney, "~> 1.15.2"},
      {:jason, ">= 1.0.0"},
      {:html_sanitize_ex, "~> 1.3.0-rc3"},
      {:hui, "~> 0.1"},
      {:mock, "~> 0.3.5", only: :test},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.5.0-rc.2", only: [:dev, :test], runtime: false}
    ]
  end
end
