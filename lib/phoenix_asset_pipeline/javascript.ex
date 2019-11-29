defmodule PhoenixAssetPipeline.Javascript do
  @javascripts_path "assets/javascripts"

  def javascripts_path, do: @javascripts_path

  def new(path) do
    js_paths = FastGlobal.get(:js_paths) || []

    %{content: _, digest: digest, integrity: integrity} =
      case Enum.member?(js_paths, path) do
        true -> FastGlobal.get("js_#{path}")
        false -> generate_js(path, js_paths)
      end

    %{digest: digest, integrity: "sha384-" <> integrity}
  end

  defp generate_js(path, js_paths) do
    with {:ok, coffee} <- File.read("#{@javascripts_path}/#{path}.coffee"),
         js <- Coffee.compile(coffee) do
      digest = Base.encode16(:erlang.md5(js), case: :lower)
      integrity = :crypto.hash(:sha384, js) |> Base.encode64()
      full_path = "/#{path}-#{digest}.js"

      FastGlobal.put(full_path, %{content: js, digest: digest, integrity: integrity})
      FastGlobal.put(:js_paths, [full_path | js_paths])
      %{content: js, digest: digest, integrity: integrity}
    else
      {:error, msg} -> raise msg
    end
  end
end
