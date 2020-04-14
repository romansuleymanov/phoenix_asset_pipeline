defmodule PhoenixAssetPipeline.Pipelines.CoffeeScript do
  @moduledoc false

  alias PhoenixAssetPipeline.Storage

  @base_path "assets/javascripts"
  @prefix "js_"

  def base_path, do: @base_path

  def new(path) do
    %{content: _, digest: digest, integrity: integrity} =
      path
      |> Storage.key(@prefix)
      |> Storage.get() || generate_js(path)

    %{digest: digest, integrity: "sha384-" <> integrity}
  end

  def prefix, do: @prefix

  defp generate_js(path, js_paths) do
    with {:ok, coffee} <- File.read("#{@base_path}/#{path}.coffee"),
         {:ok, js} <- {:ok, coffee} do
      digest =
        js
        |> :erlang.md5()
        |> Base.encode16(case: :lower)

      integrity =
        :sha384
        |> :crypto.hash(js)
        |> Base.encode64()

      path
      |> Storage.key(@prefix)
      |> Storage.put(%{content: js, digest: digest, integrity: integrity})

      {digest, integrity}
    else
      {:error, msg} -> raise msg
    end
  end
end
