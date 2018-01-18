defmodule Poker.Mixfile do
  use Mix.Project

  def project do
    [
      app: :poker,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Poker, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 0.9.0-rc1", only: [:dev, :test], runtime: false}
    ]
  end
end
