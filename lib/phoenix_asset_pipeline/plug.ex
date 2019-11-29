defmodule PhoenixAssetPipeline.Plug do
  import Plug.Conn

  def init(_opts) do
  end

  def call(
        %Plug.Conn{
          host: "assets." <> _domain,
          request_path: request_path
        } = conn,
        _
      ) do
    js = FastGlobal.get(request_path)

    conn
    |> send_resp(200, js[:content])
    |> halt()
  end

  def call(conn, _), do: conn
end
