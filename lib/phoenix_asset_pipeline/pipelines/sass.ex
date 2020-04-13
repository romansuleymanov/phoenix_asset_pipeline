defmodule PhoenixAssetPipeline.Pipelines.Sass do
  @moduledoc false

  alias PhoenixAssetPipeline.Storage

  @base_path "assets/stylesheets"
  @prefix "css_"

  def base_path, do: @base_path

  def new(path), do: content(path)

  def prefix, do: @prefix

  defp compile(""), do: {:ok, ""}

  defp compile(sass) do
    sass
    |> Sass.compile(%{include_paths: [@base_path], is_indented_syntax: true, output_style: 3})
  end

  defp content(path) do
    path
    |> Storage.key(@prefix)
    |> Storage.get() || generate_css(path)
  end

  defp generate_css(path) do
    file_path = "#{@base_path}/#{path}.sass"

    with {:ok, sass} <- File.read(file_path),
         {:ok, css} <- compile(sass) do
      path
      |> Storage.key(@prefix)
      |> Storage.put(css)

      css
    else
      {:error, :enoent} ->
        raise File.Error,
          reason: :enoent,
          action: "read file",
          path: IO.chardata_to_string(file_path)

      _ ->
        ""
    end
  end
end
