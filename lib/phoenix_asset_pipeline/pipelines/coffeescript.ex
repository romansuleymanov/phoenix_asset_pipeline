defmodule PhoenixAssetPipeline.Pipelines.CoffeeScript do
  @moduledoc false

  alias PhoenixAssetPipeline.Storage

  @base_path "assets/javascripts"
  @prefix "js_"

  def base_path, do: @base_path

  def new(path) do
    js_paths = Storage.get(:js_paths) || []

    %{content: _, digest: digest, integrity: integrity} =
      case path in js_paths do
        true -> Storage.get("js_#{path}")
        false -> generate_js(path, js_paths)
      end

    %{digest: digest, integrity: "sha384-" <> integrity}
  end

  def prefix, do: @prefix

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

      Storage.put("js_#{path}", %{content: js, digest: digest, integrity: integrity})
      Storage.put(:js_paths, [path | js_paths])

      %{content: js, digest: digest, integrity: integrity}
    else
      {:error, msg} -> raise msg
    end
  end
end
