defmodule PhoenixAssetPipeline.Config do
  @moduledoc """
  """

  # def defaults do
  #   http: [port: 4001],
  #   start_application: Mix.env() == :dev
  # end

  def resolve_value({m, f, a}) when is_atom(m) and is_atom(f), do: apply(m, f, a)
  def resolve_value(v), do: v
end
