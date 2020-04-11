defmodule PhoenixAssetPipeline do
  @moduledoc """
  PhoenixAssetPipeline
  """

  # defmacro __using__(module) do
  #   quote do
  #     def config do
  #       Application.get_env(:phoenix_asset_pipeline, unquote(module), [])
  #     end

  #     def config(key, default \\ nil) do
  #       config()
  #       |> Keyword.get(key, default)
  #     end
  #   end
  # end

  alias __MODULE__.{Endpoint, Watcher}

  # def init(key, opts) do
  #   IO.inspect  Application.get_env(:mia, MiaWeb.Endpoint, [])

  #    {:ok, []}
  # end

  def start(_type, _args) do
    # endpoint = Application.fetch_env!(:phoenix_asset_pipeline, :endpoint)
    # otp_app = Application.fetch_env!(:phoenix_asset_pipeline, :otp_app)

    # IO.inspect  Application.get_env(:mia, MiaWeb.Endpoint, [])

    config = [
      http: [port: 4001],
      otp_app: :mia
    ]

    children = [Watcher | Phoenix.Endpoint.Cowboy2Adapter.child_specs(Endpoint, config)]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
