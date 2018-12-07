defmodule AdventOfCode2018.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent_of_code_2018,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application, do: [extra_applications: [:logger]]

  defp deps do
    [
      {:flow, "~> 0.14"},
      {:mix_test_watch, "~> 0.9"}
    ]
  end
end
