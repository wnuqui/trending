defmodule Trending.Mixfile do
  use Mix.Project

  def project do
    [app: :trending,
     version: "0.1.0",
     elixir: "~> 1.4",
     escript: escript(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     preferred_cli_env: [vcr: :test]
   ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:floki, "~> 0.17.0"},
      {:httpoison, "~> 0.11.1"},
      {:poison, "~> 3.0"},
      {:exvcr, "~> 0.8", only: :test}
    ]
  end

  defp escript() do
    [main_module: Trending.CLI]
  end
end
