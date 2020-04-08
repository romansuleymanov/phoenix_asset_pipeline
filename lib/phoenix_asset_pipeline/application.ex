defmodule PhoenixAssetPipeline.Application do
  @moduledoc false

  use Application

  import Plug.Cowboy
  alias PhoenixAssetPipeline.{Plug, Watcher}

  require Logger

  def start(_type, _args) do
    scheme = :http
    server = child_spec(scheme: scheme, plug: Plug, port: 4001)
    ref = elem(server.id, 1)

    children = [
      server,
      Watcher
    ]

    case Supervisor.start_link(children, strategy: :one_for_one) do
      {:ok, pid} ->
        Logger.info(fn -> info(scheme, ref) end)
        {:ok, pid}

      {:error, {:shutdown, {_, _, {{_, {:error, :eaddrinuse}}, _}}}} = error ->
        Logger.error([info(scheme, ref), " failed, port already in use"])
        error

      {:error, _} = error ->
        error
    end
  end

  defp info(scheme, ref) do
    "Start asset pipeline server at #{bound_address(scheme, ref)}"
  end

  defp bound_address(scheme, ref) do
    {addr, port} = :ranch.get_addr(ref)
    "#{:inet.ntoa(addr)}:#{port} (#{scheme})"
  end
end
