defmodule PhoenixAssetPipeline.Application do
  @moduledoc false

  use Application

  import Plug.Cowboy, only: [child_spec: 1]
  alias PhoenixAssetPipeline.{Plug, Watcher}

  @port 4001
  @scheme :http

  require Logger

  def start(_type, _args) do
    children = [
      Watcher,
      cowboy_spec = child_spec(scheme: @scheme, plug: Plug, port: @port)
    ]

    {_, ref} = cowboy_spec.id

    case Supervisor.start_link(children, strategy: :one_for_one) do
      {:ok, pid} ->
        Logger.info(fn -> info(ref) end)
        {:ok, pid}

      {:error, {:shutdown, {_, _, {{_, {:error, :eaddrinuse}}, _}}}} = error ->
        Logger.error([info(ref), " failed, port already in use"])
        error

      {:error, _} = error ->
        error
    end
  end

  defp info(ref) do
    {addr, port} = :ranch.get_addr(ref)
    "Start asset pipeline server at #{:inet.ntoa(addr)}:#{port} (#{@scheme})"
  end
end
