defmodule PhoenixAssetPipeline.Endpoint do
  @moduledoc false

  import Plug.Conn
  alias PhoenixAssetPipeline.Plugs.{JavaScript, Static}

  def init(opts), do: opts

  def call(conn, opts) do
    force_ssl = Keyword.get(opts, :force_ssl, false)

    case force_ssl do
      false -> conn
      _ -> Plug.SSL.call(conn, Plug.SSL.init(force_ssl))
    end
    |> JavaScript.call([])
    |> Static.call(config())

    # |> put_resp_content_type("text/plain")
    # |> send_resp(404, "not found")
  end

  def __handler__(conn, opts) do
    {:plug, conn, __MODULE__, opts}
  end

  defp config do
    [
      at: "/img",
      from: "assets/images"
    ]
  end
end
