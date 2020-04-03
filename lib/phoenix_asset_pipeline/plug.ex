defmodule PhoenixAssetPipeline.Plug do
  import Plug.Builder

  # plug(PhoenixAssetPipeline.Plugs.CoffeeScript)
  plug(PhoenixAssetPipeline.Plugs.Static, at: "/img")
end
