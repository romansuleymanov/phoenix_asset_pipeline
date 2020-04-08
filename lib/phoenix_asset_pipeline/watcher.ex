defmodule PhoenixAssetPipeline.Watcher do
  @moduledoc false

  use GenServer

  import PhoenixAssetPipeline.Storage
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
    %{"path" => path} = Regex.named_captures(~r/\/#{base_path}\/(?<path>.+)#{extname}/, path)

    if path in paths do
      update_paths(extname, path, paths)
    else
      for path <- paths, do: delete_path(extname, path)
      delete_paths(extname)
    end

    {:noreply, state}
  end

  defp delete_path(".sass", path) do
    path
    |> Stylesheet.asset_key()
    |> delete()
  end

  # defp delete_path(".coffee", path) do
  #   path
  #   |> CoffeeScript.asset_key
  #   |> delete()
  # end

  defp delete_paths(".sass") do
    Stylesheet.paths_key() |> delete()
  end

  # defp delete_paths(".coffee") do
  #   CoffeeScript.paths_key() |> delete()
  # end

  defp metadata(".sass") do
    %{base_path: Stylesheet.base_path(), paths: get(Stylesheet.paths_key(), [])}
  end

  defp metadata(".coffee") do
    %{base_path: "", paths: []}
  end

  defp metadata(_), do: %{base_path: "", paths: []}

  defp update_paths(".sass" = extname, path, paths) do
    delete_path(extname, path)
    Stylesheet.paths_key() |> put(List.delete(paths, path))
  end

  # defp update_paths(".coffee" = extname, path, paths) do
  #   delete_path(extname, path)
  #   CoffeeScript.paths_key() |> put(List.delete(paths, path))
  # end
end
