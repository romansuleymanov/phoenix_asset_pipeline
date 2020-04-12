defmodule PhoenixAssetPipeline.Endpoint do
  @moduledoc false

  alias PhoenixAssetPipeline.Plugs.{JavaScript, Static}

  def init(opts) do
    [
      at: "/img",
      from: "assets/images"
    ]
    |> Keyword.merge(opts)
  end

  def call(conn, opts) do
    force_ssl = Keyword.get(opts, :force_ssl, false)

    case force_ssl do
      false -> conn
      _ -> Plug.SSL.call(conn, Plug.SSL.init(force_ssl))
    end
    |> JavaScript.call([])
    |> Static.call(opts)
  end

  def __handler__(conn, opts) do
    {:plug, conn, __MODULE__, opts}
  end
end
