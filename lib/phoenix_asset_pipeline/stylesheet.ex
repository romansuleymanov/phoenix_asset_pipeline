defmodule PhoenixAssetPipeline.Stylesheet do
  @stylesheets_path "assets/stylesheets"

  def new(path) do
    css_paths = FastGlobal.get(:css_paths) || []

    case Enum.member?(css_paths, path) do
      true -> FastGlobal.get("css_#{path}")
      false -> generate_css(path, css_paths)
    end
  end

  def stylesheets_path, do: @stylesheets_path

  defp compile_sass(sass) when sass == "", do: {:ok, sass}

  defp compile_sass(sass) do
    Sass.compile(sass, %{include_paths: [@stylesheets_path], is_indented_syntax: true})
  end

  defp generate_css(path, css_paths) do
    with {:ok, sass} <- File.read("#{@stylesheets_path}/#{path}.sass"),
         {:ok, css} <- compile_sass(sass) do
      FastGlobal.put("css_#{path}", css)
      FastGlobal.put(:css_paths, [path | css_paths])
      css
    else
      {:error, msg} -> raise msg
    end
  end
end
