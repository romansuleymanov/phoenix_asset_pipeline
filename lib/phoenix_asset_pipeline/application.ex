defmodule PhoenixAssetPipeline.Application do
  @moduledoc false

  use Application

  import Plug.Cowboy
  alias PhoenixAssetPipeline.{Plug, Watcher}

  def start(_type, _args) do
    children = [
      child_spec(scheme: :http, plug: Plug, port: 4001),
      Watcher
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
