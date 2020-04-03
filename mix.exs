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
      mod: application_mod(Mix.env()),
      extra_applications: [:logger]
    ]
  end

  def application_mod(:dev) do
    if iex_running?(), do: application_mod(), else: {PhoenixAssetPipeline.Application, []}
  end

  def application_mod(_), do: application_mod()
  def application_mod, do: []

  defp iex_running? do
    Code.ensure_loaded?(IEx) and IEx.started?()
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
      {:credo, "~> 1.4.0-rc.1", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:fastglobal, "~> 1.0"},
      {:file_system, "~> 0.2"},
      {:phoenix_html, "~> 2.14"},
      {:plug_cowboy, "~> 2.1"},
      {:sass_compiler, "~> 0.1"}
    ]
  end
end
