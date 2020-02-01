defmodule PhoenixAssetPipeline.Watcher do
  use GenServer

  alias PhoenixAssetPipeline.Stylesheet

  @root Path.expand("./") <> "/"

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
    extname = Path.extname(path)

    file =
      path
      |> relative_path()
      |> file_without_extname(extname)

    key =
      case extname do
        ".coffee" -> :js_paths
        ".sass" -> :css_paths
      end

    paths = FastGlobal.get(key) || []
    unless file in paths, do: FastGlobal.put(key, [])

    {:noreply, state}
  end

  defp file_without_extname(file, extname) do
    extname_length = String.length(extname)
    file_length = String.length(file)

    String.slice(file, 0, file_length - extname_length)
  end

  defp relative_path(path) do
    root_length = String.length(@root)
    path_length = String.length(path)

    String.slice(path, root_length, path_length - root_length)
  end
end
