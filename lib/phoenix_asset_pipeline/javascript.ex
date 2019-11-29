defmodule PhoenixAssetPipeline.Javascript do
  def new(path) do
    %{async: true, src: "/#{path}.js", integrity: ""}
  end
end
