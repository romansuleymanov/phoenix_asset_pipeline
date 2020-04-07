defmodule PhoenixAssetPipeline.Storage do
  @moduledoc false

  def delete(key), do: FastGlobal.delete(key)
  def get(key), do: FastGlobal.get(key)
  def get(key, default_value), do: get(key) || default_value
  def put(key, value), do: FastGlobal.put(key, value)
end
