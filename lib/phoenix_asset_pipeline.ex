defmodule PhoenixAssetPipeline do
  @moduledoc """
  PhoenixAssetPipeline
  """

  alias __MODULE__.{Endpoint, Watcher}

  def start(_type, _args) do
    children = [Watcher | Phoenix.Endpoint.Cowboy2Adapter.child_specs(Endpoint, config)]
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  defp config do
    [
      http: [port: 4001],
      otp_app: :phoenix_asset_pipeline
    ]
  end
end
