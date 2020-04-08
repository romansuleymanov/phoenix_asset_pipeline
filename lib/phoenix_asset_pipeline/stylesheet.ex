defmodule PhoenixAssetPipeline.Stylesheet do
  @moduledoc false
  import Phoenix.HTML, only: [raw: 1]
  alias PhoenixAssetPipeline.Storage

  @base_path "assets/stylesheets"
  @paths_key :css_paths

  def asset_key(path), do: :"css_#{path}"

  def base_path, do: @base_path

  def new(path) do
    path
    |> content
    |> raw
  end

  def paths_key, do: @paths_key

  defp compile_sass(""), do: {:ok, ""}

  defp compile_sass(sass) do
    sass
    |> Sass.compile(%{include_paths: [@base_path], is_indented_syntax: true, output_style: 3})
  end

  defp content(path) do
    Storage.get(asset_key(path)) || generate_css(path)
  end

  defp generate_css(path) do
    file_path = "#{@base_path}/#{path}.sass"

    with {:ok, sass} <- File.read(file_path),
         {:ok, css} <- compile_sass(sass) do
      Storage.put(asset_key(path), css)

      case Storage.get(@paths_key, []) do
        [] -> Storage.put(@paths_key, [path])
        paths -> unless path in paths, do: Storage.put(@paths_key, [path | paths])
      end

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
