defmodule PhoenixAssetPipeline.Plug do
  @moduledoc false

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
    %{"path" => path} =
      ~r/\/(?<path>.+)-.+\.js/
      |> Regex.named_captures(request_path)

    js = FastGlobal.get("js_#{path}")

    conn
    |> send_resp(200, js[:content])
    |> halt()
  end

  def call(conn, _), do: conn
end
