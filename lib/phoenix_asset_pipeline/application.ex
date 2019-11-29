defmodule PhoenixAssetPipeline.Application do
  use Application

  alias PhoenixAssetPipeline.FileWatcher

  def start(_type, _args) do
    Supervisor.start_link([FileWatcher], strategy: :one_for_one)
  end
end
