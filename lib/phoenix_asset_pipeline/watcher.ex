defmodule PhoenixAssetPipeline.Watcher do
  use GenServer

  alias PhoenixAssetPipeline.Stylesheet

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(_args) do
    {:ok, watcher_pid} = FileSystem.start_link(dirs: [Stylesheet.stylesheets_path()])
    FileSystem.subscribe(watcher_pid)
    {:ok, %{watcher_pid: watcher_pid}}
  end

  def handle_info(
        {:file_event, watcher_pid, {path, _events}},
        %{watcher_pid: watcher_pid} = state
      ) do
    case Path.extname(path) do
      ".coffee" -> FastGlobal.put(:javascript_paths, [])
      ".sass" -> FastGlobal.put(:stylesheet_paths, [])
    end

    {:noreply, state}
  end
end
