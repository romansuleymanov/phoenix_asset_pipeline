defmodule PhoenixAssetPipeline.Storage do
  @moduledoc """
  This module implements the `PhoenixAssetPipeline.Storage` and stores the data with
  [:persistent_term](https://erlang.org/doc/man/persistent_term.html).
  """

  def key(path, prefix), do: String.to_atom(prefix <> path)

  def drop(path, prefix) do
    path
    |> key(prefix)
    |> :persistent_term.erase() ||
      for(key <- key_list(prefix), do: :persistent_term.erase(key))
  end

  def key_list(prefix),
    do:
      :lists.filter(
        &String.starts_with?(&1 |> Atom.to_string(), prefix),
        :persistent_term.get() |> Keyword.keys()
      )

  defdelegate get(key, default \\ nil), to: :persistent_term
  defdelegate put(key, value), to: :persistent_term
end
