defmodule PhoenixAssetPipeline.Application do
  @moduledoc false

  use Application

  alias PhoenixAssetPipeline.Watcher

  def start(_type, _args) do
    Supervisor.start_link([Watcher], strategy: :one_for_one)
  end
end
