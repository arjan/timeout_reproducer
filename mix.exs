defmodule TimeoutReproducer.MixProject do
  use Mix.Project

  def project do
    [
      app: :timeout_reproducer,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TimeoutReproducer.App, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:postgrex, "0.13.5"},
      {:db_connection, "1.1.3"},
      {:poolboy, "1.5.1"}
    ]
  end
end
