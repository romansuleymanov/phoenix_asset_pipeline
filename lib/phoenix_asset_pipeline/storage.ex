defmodule PhoenixAssetPipeline.Storage do
  @moduledoc """
  This module implements the `PhoenixAssetPipeline.Storage` and stores the data with
  [:persistent_term](https://erlang.org/doc/man/persistent_term.html).
  """

  def key(path, prefix), do: prefix <> path

  def drop(path, prefix) do
    path
    |> key(prefix)
    |> :persistent_term.erase() ||
      for(key <- key_list(prefix), do: :persistent_term.erase(key))
  end

  defp key_list(prefix),
    do: :maps.filter(fn path -> String.starts_with?(path, prefix) end, :persistent_term.get())

  defdelegate get(key, default \\ nil), to: :persistent_term
  defdelegate put(key, value), to: :persistent_term
end
