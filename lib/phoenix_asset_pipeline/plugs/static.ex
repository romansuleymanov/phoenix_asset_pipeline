defmodule PhoenixAssetPipeline.Plugs.Static do
  @moduledoc false

  def init(opts) do
    [
      at: Keyword.get(opts, :at, "/"),
      brotli?: true,
      from: from,
      gzip?: true
    ]
  end

  def call(conn, opts) do
    conn
    |> Plug.Static.call(Plug.Static.init(opts))
  end

  defp from do
    Application.fetch_env!(:phoenix_asset_pipeline, :from)
  end
end
