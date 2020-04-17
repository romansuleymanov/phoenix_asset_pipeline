defmodule PhoenixAssetPipeline.Endpoint do
  @moduledoc false

  use Plug.Builder

  alias Plug.SSL
  alias PhoenixAssetPipeline.Plugs.{JavaScript, Static}

  plug(:ssl)
  plug(:static)
  plug(:javascript)
  plug(:not_found)

  def __handler__(conn, opts) do
    {:plug, conn, __MODULE__, opts}
  end

  defp javascript(conn, _opts) do
    JavaScript.call(conn, [])
  end

  defp not_found(conn, _opts) do
    send_resp(conn, 404, "not found")
  end

  defp ssl(conn, opts) do
    force_ssl = Keyword.get(opts, :force_ssl, false)

    case force_ssl do
      false -> conn
      _ -> SSL.call(conn, SSL.init(force_ssl))
    end
  end

  defp static(conn, _opts) do
    Static.call(conn, at: "/img", from: "assets/images")
  end
end
