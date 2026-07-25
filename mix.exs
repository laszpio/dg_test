defmodule DgTest.MixProject do
  use Mix.Project

  def project do
    [
      app: :dg_test,
      version: "0.1.0",
      elixir: "~> 1.14",
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
      {:tesla, "~> 1.20"},
      {:hackney, "~> 4.5.2"},
      {:jason, "~> 1.4"},
      {:html_sanitize_ex, "~> 1.4"},
      {:hui, "~> 0.11"},
      {:mock, "~> 0.3.9", only: :test},
      {:dialyxir, "~> 1.4", only: [:dev], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end
end
