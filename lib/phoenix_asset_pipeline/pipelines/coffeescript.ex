defmodule PhoenixAssetPipeline.Pipelines.CoffeeScript do
  @moduledoc false

  alias PhoenixAssetPipeline.Storage

  @base_path "assets/javascripts"
  @prefix "phoenix_asset_pipeline_js_"

  def base_path, do: @base_path

  def new(path) do
    path
    |> Storage.key(@prefix)
    |> Storage.get() || compile(path)
  end

  def prefix, do: @prefix

  defp compile(path) do
    case Coffee.compile("#{@base_path}/#{path}.coffeee") do
      {:ok, js} ->
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
        |> Storage.put({js, digest, integrity})

        {js, digest, integrity}

      {:error, error} ->
        raise error
    end
  end
end
