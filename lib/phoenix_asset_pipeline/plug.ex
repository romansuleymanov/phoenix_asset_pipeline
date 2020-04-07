defmodule PhoenixAssetPipeline.Plug do
  @moduledoc false

  alias PhoenixAssetPipeline.Plugs.CoffeeScript
  alias PhoenixAssetPipeline.Plugs.Static

  def init(opts), do: opts

  def call(conn, opts) do
    conn
    # |> CoffeeScript.call(CoffeeScript.init(opts))
    |> Static.call(Static.init(at: "/img"))
  end
end
