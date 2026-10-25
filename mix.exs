defmodule DgTest.MixProject do
  use Mix.Project

  def project do
    [
      app: :dg_test,
      version: "0.1.0",
      elixir: "~> 1.20",
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
      {:tesla, "~> 1.22"},
      {:hackney, "~> 4.8"},
      {:jason, "~> 1.4"},
      {:html_sanitize_ex, "~> 1.4"},
      {:hui, "~> 0.11"},
      {:mock, "~> 0.3.9", only: :test},
      # mock 0.3.9 pins meck ~> 0.9.2, which fails to compile on OTP 29
      {:meck, "~> 1.2", only: :test, override: true},
      {:dialyxir, "~> 1.4", only: [:dev], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end
end
