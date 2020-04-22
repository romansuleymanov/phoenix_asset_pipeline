defmodule PhoenixAssetPipeline.Pipelines.CoffeeScript do
  @moduledoc false

  alias PhoenixAssetPipeline.Storage

  @base_path "assets/javascripts"
  @prefix "js_"

  def base_path, do: @base_path

  def new(path) do
    path
    |> Storage.key(@prefix)
    |> Storage.get() || content(path)
  end

  def prefix, do: @prefix

  defp compile(coffee), do: Coffee.compile(coffee)

  defp content(path) do
    file_path = "#{@base_path}/#{path}.coffee"

    with {:ok, coffee} <- File.read(file_path),
         {:ok, js} <- compile(coffee) do
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
    else
      {:error, :enoent} ->
        raise File.Error,
          reason: :enoent,
          action: "read file",
          path: IO.chardata_to_string(file_path)

      _ ->
        ""
    end
  end
end
