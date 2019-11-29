defmodule PhoenixAssetPipeline do
  @moduledoc """
  PhoenixAssetPipeline provides helpers to add styles and scripts in views.

  ## Integrate in Phoenix
  The simplest way to add the helpers to Phoenix is to `import PhoenixAssetPipeline`
  either in your `web.ex` under views to have it available under every views,
  or under for example `App.LayoutView` to have it available in your layout.
  """

  use Phoenix.HTML

  alias PhoenixAssetPipeline.Javascript
  alias PhoenixAssetPipeline.Stylesheet

  @subdomain "assets."

  def style_tag(path) do
    content_tag(:style, path |> Stylesheet.new() |> raw)
  end

  def script_tag(%Plug.Conn{req_headers: req_headers, scheme: scheme} = _conn, path) do
    %{digest: digest, integrity: integrity} = Javascript.new(path)

    headers = Enum.into(req_headers, %{})

    content_tag(:script, "",
      async: true,
      src: "#{scheme}://#{@subdomain}#{headers["host"]}/#{path}-#{digest}.js",
      integrity: integrity
    )
  end

  def subdomain, do: @subdomain
end
