defmodule PhoenixAssetPipeline.Plugs.Static do
  @moduledoc false
  alias Plug.Static

  def init(opts) do
    [
      at: Keyword.get(opts, :at, "/"),
      brotli?: true,
      from: from(),
      gzip?: true
    ]
  end

  def call(conn, opts) do
    Static.call(conn, Static.init(opts))
  end

  defp from do
    Application.fetch_env!(:phoenix_asset_pipeline, :from)
  end
end
