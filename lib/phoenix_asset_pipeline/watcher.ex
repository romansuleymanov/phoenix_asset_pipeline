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
    %{base_path: base_path, key_list: storage_keys} = metadata(extname)

    %{"path" => path} = Regex.named_captures(~r/\/#{base_path}\/(?<path>.+)#{extname}/, path)
    key = asset_key(extname, path)

    if key in storage_keys do
      delete(key)
    else
      for key <- storage_keys, do: delete(key)
    end

    {:noreply, state}
  end

  defp asset_key(".sass", path), do: Stylesheet.asset_key(path)
  # defp asset_key(".coffee", path), do: CoffeeScript.asset_key(path)
  defp asset_key(_, path), do: path

  defp metadata(".sass") do
    %{base_path: Stylesheet.base_path(), key_list: Stylesheet.key_list()}
  end

  # defp metadata(".coffee") do
  #   %{base_path: CoffeeScript.base_path(), key_list: CoffeeScript.key_list()}
  # end

  defp metadata(_), do: %{base_path: "", key_list: []}
end
