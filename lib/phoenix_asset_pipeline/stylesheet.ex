defmodule PhoenixAssetPipeline.Stylesheet do
  @stylesheets_path "assets/stylesheets"

  def new(path) do
    stylesheet_paths = FastGlobal.get(:stylesheet_paths) || []

    case Enum.member?(stylesheet_paths, path) do
      true -> FastGlobal.get("css_#{path}")
      false -> generate_css(path, stylesheet_paths)
    end
  end

  def stylesheets_path, do: @stylesheets_path

  defp compile_sass(sass) when sass == "", do: {:ok, sass}

  defp compile_sass(sass) do
    Sass.compile(sass, %{include_paths: [@stylesheets_path], is_indented_syntax: true})
  end

  defp generate_css(path, stylesheet_paths) do
    with {:ok, sass} <- File.read("#{@stylesheets_path}/#{path}.sass"),
         {:ok, css} <- compile_sass(sass) do
      FastGlobal.put("css_#{path}", css)
      FastGlobal.put(:stylesheet_paths, [path | stylesheet_paths])
      css
    else
      {:error, msg} -> raise msg
    end
  end
end
