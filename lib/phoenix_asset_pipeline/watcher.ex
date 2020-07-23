defmodule PhoenixAssetPipeline.Watcher do
  @moduledoc false

  use GenServer

  alias PhoenixAssetPipeline.Storage
  alias PhoenixAssetPipeline.Pipelines.{CoffeeScript, Sass}

  def init(_) do
    {:ok, pid} =
      FileSystem.start_link(dirs: ["assets/javascripts", "assets/stylesheets"], latency: 0)

    FileSystem.subscribe(pid)
    {:ok, %{watcher_pid: pid}}
  end

  def handle_info({:file_event, _, {path, _}}, %{watcher_pid: _} = state) do
    extname = Path.extname(path)
    [base_path, prefix] = metadata(extname)
    %{"path" => path} = Regex.named_captures(~r/\/#{base_path}\/(?<path>.+)#{extname}/, path)

    Storage.drop(path, prefix)
    {:noreply, state}
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  defp metadata(".sass"), do: [Sass.base_path(), Sass.prefix()]
  defp metadata(".coffee"), do: [CoffeeScript.base_path(), CoffeeScript.prefix()]
  defp metadata(_), do: ["", ""]
end
