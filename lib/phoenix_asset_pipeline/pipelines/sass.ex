defmodule PhoenixAssetPipeline.Pipelines.Sass do
  @moduledoc false

  alias PhoenixAssetPipeline.Storage

  @base_path "assets/stylesheets"
  @prefix "css_"

  def asset_key(path), do: @prefix <> path
  def base_path, do: @base_path

  def key_list do
    :maps.filter(fn path -> String.starts_with?(path, @prefix) end, Storage.list())
  end

  def new(path), do: content(path)

  defp compile(""), do: {:ok, ""}

  defp compile(sass) do
    sass
    |> Sass.compile(%{include_paths: [@base_path], is_indented_syntax: true, output_style: 3})
  end

  defp content(path) do
    Storage.get(asset_key(path)) || generate_css(path)
  end

  defp generate_css(path) do
    file_path = "#{@base_path}/#{path}.sass"

    with {:ok, sass} <- File.read(file_path),
         {:ok, css} <- compile(sass) do
      Storage.put(asset_key(path), css)

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
