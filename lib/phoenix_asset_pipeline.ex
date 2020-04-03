defmodule PhoenixAssetPipeline do
  @moduledoc """
  PhoenixAssetPipeline provides helpers to add styles and scripts in views.

  ## Integrate in Phoenix
  The simplest way to add the helpers to Phoenix is to `import PhoenixAssetPipeline`
  either in your `web.ex` under views to have it available under every views,
  or under for example `App.LayoutView` to have it available in your layout.
  """

  import Phoenix.HTML.Tag, only: [content_tag: 2, content_tag: 3]

  alias PhoenixAssetPipeline.{Javascript, Stylesheet}

  @subdomain "assets."

  def style_tag(path), do: content_tag(:style, Stylesheet.new(path))

  def script_tag(path) do
    %{digest: digest, integrity: integrity} = Javascript.new(path)

    content_tag(:script, "",
      async: true,
      src: "http://localhost:4001/js/#{path}-#{digest}.js",
      integrity: integrity
    )
  end

  def subdomain, do: @subdomain
end
