defmodule PhoenixAssetPipeline.MixProject do
  use Mix.Project

  @version "0.1.0"
  @description """
  Asset pipeline for Phoenix app
  """

  def project do
    [
      app: :phoenix_asset_pipeline,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      description: @description,
      package: package(),
      deps: deps(),
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ],
      source_url: "https://github.com/Youimmi/phoenix_asset_pipeline"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {PhoenixAssetPipeline, []},
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      files: ["lib", "LICENSE", "mix.exs", "README.md"],
      maintainers: [],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Youimmi/phoenix_asset_pipeline"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:brotli, "~> 0.2"},
      {:coffee_compiler, "~> 0.1"},
      {:credo, "~> 1.4.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:file_system, "~> 0.2"},
      {:phoenix, "~> 1.5.0"},
      {:phoenix_html, "~> 2.14"},
      {:plug_cowboy, "~> 2.2"},
      {:sass_compiler, "~> 0.1"}
    ]
  end
end
