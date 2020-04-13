defmodule PhoenixAssetPipeline.Watcher do
  @moduledoc false

  use GenServer

  import PhoenixAssetPipeline.Storage
  alias PhoenixAssetPipeline.Pipelines.{CoffeeScript, Sass}

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
    [base_path | key_list] = metadata(extname)
    %{"path" => path} = Regex.named_captures(~r/\/#{base_path}\/(?<path>.+)#{extname}/, path)
    key = asset_key(extname, path)

    clean_storage(key, key_list)
    {:noreply, state}
  end

  defp asset_key(".sass", path), do: Sass.asset_key(path)
  defp asset_key(".coffee", path), do: CoffeeScript.asset_key(path)
  defp asset_key(_, path), do: path

  defp clean_storage(key, keys) when key in keys, do: delete(key)

  defp clean_storage(key, keys) do
    for key <- key_list, do: delete(key)
  end

  defp metadata(".sass"), do: [Sass.base_path(), Sass.key_list()]
  defp metadata(".coffee"), do: [Sass.base_path(), CoffeeScript.key_list()]
  defp metadata(_), do: ["", []]
end
