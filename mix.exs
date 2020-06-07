defmodule ThreadCollector.MixProject do
  use Mix.Project

  def project do
    [
      app: :thread_collector,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ThreadCollector.Application, []}
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.2"},
      {:mojito, "~> 0.6.4"},
      {:plug_cowboy, "~> 2.0"}
    ]
  end
end
