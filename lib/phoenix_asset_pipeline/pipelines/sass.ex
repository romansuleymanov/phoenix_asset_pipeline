defmodule PhoenixAssetPipeline.Pipelines.Sass do
  @moduledoc false

  alias PhoenixAssetPipeline.Storage

  @base_path "assets/stylesheets"
  @prefix "phoenix_asset_pipeline_css_"

  def base_path, do: @base_path

  def new(path) do
    path
    |> Storage.key(@prefix)
    |> Storage.get() || compile(path)
  end

  def prefix, do: @prefix

  defp compile(path) do
    case Sass.compile_file("#{@base_path}/#{path}.sass", %{
           include_paths: [@base_path],
           is_indented_syntax: true,
           output_style: 3
         }) do
      {:ok, css} ->
        path
        |> Storage.key(@prefix)
        |> Storage.put(css)

        css

      {:error, error} ->
        raise error
    end
  end
end
