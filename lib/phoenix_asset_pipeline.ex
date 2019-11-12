defmodule PhoenixAssetPipeline do
  @moduledoc """
  PhoenixAssetPipeline provides helpers to add styles and scripts in views.

  ## Integrate in Phoenix
  The simplest way to add the helpers to Phoenix is to `import PhoenixAssetPipeline`
  either in your `web.ex` under views to have it available under every views,
  or under for example `App.LayoutView` to have it available in your layout.
  """

  use Phoenix.HTML

  @stylesheets_path "assets/stylesheets"

  def style_tag(path) do
    with {:ok, sass} <- File.read("#{@stylesheets_path}/#{path}.sass"),
         {:ok, css} <- generate_css(sass) do
      content_tag(:style, raw(css))
    else
      {:error, msg} -> raise msg
    end
  end

  defp generate_css(sass) when sass == "", do: {:ok, sass}

  defp generate_css(sass) do
    Sass.compile(sass, %{include_paths: [@stylesheets_path], is_indented_syntax: true})
  end
end
