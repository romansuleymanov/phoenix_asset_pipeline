defmodule PhoenixAssetPipeline.Stylesheet do
  @moduledoc false

  import FastGlobal, only: [delete: 1, get: 1, put: 2]
  import Phoenix.HTML, only: [raw: 1]

  @base_path "assets/stylesheets"

  def new(path) do
    path
    |> content
    |> raw
  end

  def base_path, do: @base_path

  def delete_path(path) do
    path
    |> asset_key
    |> delete_key
  end

  def delete_paths, do: delete_key(:css_paths)

  def get_path(path) do
    path
    |> asset_key
    |> get_key
  end

  def get_paths, do: get_key(:css_paths) || []

  def put_paths(paths), do: put(:css_paths, paths)

  defp asset_key(path), do: :"css_#{path}"

  defp content(path), do: get_path(path) || generate_css(path)

  defp generate_css(path) do
    with {:ok, sass} <- File.read("#{@base_path}/#{path}.sass"),
         {:ok, css} <- compile_sass(sass) do
      put_css(path, css)

      case get_paths() do
        [] -> put_paths([path])
        paths -> unless path in paths, do: put_paths([path | paths])
      end

      css
    else
      {:error, msg} -> raise msg
    end
  end

  defp compile_sass(""), do: {:ok, ""}

  defp compile_sass(sass) do
    Sass.compile(sass, %{include_paths: [@base_path], is_indented_syntax: true})
  end

  defp delete_key(key), do: delete(key)
  defp get_key(key), do: get(key)
  defp put_css(path, css), do: put(asset_key(path), css)
end
