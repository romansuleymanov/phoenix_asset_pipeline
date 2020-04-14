defmodule PhoenixAssetPipeline.Plugs.JavaScript do
  import Plug.Conn

  alias PhoenixAssetPipeline.Pipelines.CoffeeScript
  alias PhoenixAssetPipeline.Storage

  @allowed_methods ~w(GET HEAD)
  def init(opts), do: opts

  def call(%{method: method, path_info: ["js" | path]} = conn, _opts)
      when method in @allowed_methods do
    %{"path" => path} = Regex.named_captures(~r/(?<path>.*)-.{32}\.js/, Enum.join(path, "/"))

    hit_cache =
      path
      |> Storage.key(CoffeeScript.prefix())
      |> Storage.get()

    {js, _digest, _integrity} =
      case hit_cache do
        nil -> CoffeeScript.new(path)
        result -> result
      end

    conn
    |> put_resp_header("access-control-allow-origin", "*")
    |> send_resp(200, js)
  end

  def call(conn, _opts), do: conn
end
