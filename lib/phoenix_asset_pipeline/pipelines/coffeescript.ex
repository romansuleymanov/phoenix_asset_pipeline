defmodule PhoenixAssetPipeline.Pipelines.CoffeeScript do
  @moduledoc false

  import PhoenixAssetPipeline.Storage

  @base_path "assets/javascripts"
  @prefix "js_"

  def asset_key(path), do: @prefix <> path
  def base_path, do: @base_path

  def new(path) do
    js_paths = get(:js_paths) || []

    %{content: _, digest: digest, integrity: integrity} =
      case path in js_paths do
        true -> get("js_#{path}")
        false -> generate_js(path, js_paths)
      end

    %{digest: digest, integrity: "sha384-" <> integrity}
  end

  defp generate_js(path, js_paths) do
    with {:ok, coffee} <- File.read("#{@base_path}/#{path}.coffee"),
         js <- coffee do
      digest =
        js
        |> :erlang.md5()
        |> Base.encode16(case: :lower)

      integrity =
        :sha384
        |> :crypto.hash(js)
        |> Base.encode64()

      put("js_#{path}", %{content: js, digest: digest, integrity: integrity})
      put(:js_paths, [path | js_paths])

      %{content: js, digest: digest, integrity: integrity}
    else
      {:error, msg} -> raise msg
    end
  end
end
