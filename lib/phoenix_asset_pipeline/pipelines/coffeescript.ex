defmodule PhoenixAssetPipeline.Pipelines.CoffeeScript do
  @moduledoc false

  alias PhoenixAssetPipeline.Storage

  @base_path "assets/javascripts"
  @prefix "js_"

  def base_path, do: @base_path

  def new(path) do
    path
    |> Storage.key(@prefix)
    |> Storage.get() || prepare_js(path)
  end

  def prefix, do: @prefix

  defp compile(path) do
    {js, _} =
      System.cmd("yarn", ["rollup", "-c", "rollup.config.js", "-i", "javascripts/#{path}.coffee"],
        cd: "assets"
      )

    {:ok, js}
  end

  defp prepare_js(path) do
    case compile(path) do
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

      _ ->
        ""
    end
  end
end
