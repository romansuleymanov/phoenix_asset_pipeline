defmodule PhoenixAssetPipeline.Watcher do
  @moduledoc false

  use GenServer

  alias PhoenixAssetPipeline.Stylesheet

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(_) do
    {:ok, pid} = FileSystem.start_link(dirs: ["assets"])
    FileSystem.subscribe(pid)
    {:ok, %{watcher_pid: pid}}
  end

  def handle_info({:file_event, _, {path, _}}, %{watcher_pid: _} = state) do
    extname = Path.extname(path)
    %{base_path: base_path, paths: paths} = metadata(extname)
    %{"path" => path} = Regex.named_captures(~r/\/#{base_path}\/(?<path>.+).*#{extname}/, path)

    if path in paths do
      Stylesheet.delete_path(path)
      Stylesheet.put_paths(List.delete(paths, path))
    else
      for path <- paths, do: Stylesheet.delete_path(path)
      Stylesheet.delete_paths()
    end

    {:noreply, state}
  end

  defp metadata(".sass"), do: %{base_path: Stylesheet.base_path(), paths: Stylesheet.get_paths()}
  defp metadata(_), do: %{base_path: "", paths: []}
end
