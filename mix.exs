defmodule Robot.MixProject do
  use Mix.Project

  def project do
    [
      app: :robot,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      name: "Robot",
      source_url: "https://github.com/Yamilquery/robot",
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Robot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Given a Robot which can only move in four directions, UP(U), DOWN(D), LEFT(L), RIGHT(R) without exceeding the established limits."
  end

  defp package() do
    [
      licenses: ["osl-3.0"],
      links: %{"GitHub" => "https://github.com/Yamilquery/robot"}
    ]
  end
end
