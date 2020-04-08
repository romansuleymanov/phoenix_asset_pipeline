defmodule PhoenixAssetPipeline.Plug do
  @moduledoc false
  use Plug.Builder

  alias PhoenixAssetPipeline.Plugs.{CoffeeScript, Static}

  # plug CoffeeScript
  plug Static, at: "/img"
end
