defmodule PhoenixAssetPipeline.Storage do
  @moduledoc """
  This module implements the `PhoenixAssetPipeline.Storage` and stores the data with
  [:persistent_term](https://erlang.org/doc/man/persistent_term.html).
  """

  defdelegate delete(key), as: :erase, to: :persistent_term
  defdelegate get(key, default \\ nil), to: :persistent_term
  defdelegate list, as: :get, to: :persistent_term
  defdelegate put(key, value), to: :persistent_term
end
