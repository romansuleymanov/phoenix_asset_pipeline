defmodule PhoenixAssetPipeline.Plugs.CoffeeScript do
  #   @behaviour Plug
  #   @allowed_methods ~w(GET HEAD)

  #   import Plug.Conn
  #   alias Plug.Conn

  #   defmodule InvalidPathError do
  #     defexception message: "invalid path for asset", plug_status: 400
  #   end

  def init(opts), do: opts

  #   def init(opts) do
  #     %{
  #       gzip?: false,
  #       brotli?: false,
  #       qs_cache: "public, max-age=31536000",
  #       et_cache: "public",
  #       et_generation: nil,
  #       headers: %{},
  #       content_types: %{}
  #     }
  #   end

  def call(%{method: _meth, path_info: ["js" | _]} = conn, _opts) do
    conn
    |> Plug.Conn.send_resp(404, "Not found")
  end

  def call(conn, _opts), do: conn

  #   def call(
  #         conn = %Conn{method: meth, path_info: ["js" | _]},
  #         %{gzip?: gzip?, brotli?: brotli?} = options
  #       )
  #       when meth in @allowed_methods do
  #     path = uri_decode(conn.request_path)

  #     if FastGlobal.get(path) do
  #       # range = get_req_header(conn, "range")
  #       # encoding = file_encoding(conn, path, range, gzip?, brotli?)
  #       # serve_static(encoding, conn, segments, range, options)
  #     else
  #       conn
  #       |> Plug.Conn.send_resp(404, "Not found")
  #     end
  #   end

  #   defp uri_decode(path) do
  #     URI.decode(path)
  #   rescue
  #     ArgumentError -> reraise(InvalidPathError, __STACKTRACE__)
  #   end

  #   # defp serve_static({content_encoding, file_info, path}, conn, segments, range, options) do
  #   #   %{
  #   #     qs_cache: qs_cache,
  #   #     et_cache: et_cache,
  #   #     et_generation: et_generation,
  #   #     headers: headers,
  #   #     content_types: types
  #   #   } = options

  #   #   case put_cache_header(conn, qs_cache, et_cache, et_generation, file_info, path) do
  #   #     {:stale, conn} ->
  #   #       filename = List.last(segments)
  #   #       content_type = Map.get(types, filename) || MIME.from_path(filename)

  #   #       conn
  #   #       |> put_resp_header("content-type", content_type)
  #   #       |> put_resp_header("accept-ranges", "bytes")
  #   #       |> maybe_add_encoding(content_encoding)
  #   #       |> merge_headers(headers)
  #   #       |> serve_range(file_info, path, range, options)

  #   #     {:fresh, conn} ->
  #   #       conn
  #   #       |> maybe_add_vary(options)
  #   #       |> send_resp(304, "")
  #   #       |> halt()
  #   #   end
  #   # end

  #   # defp serve_static(:error, conn, _segments, _range, _options) do
  #   #   conn
  #   # end

  #   # defp serve_range(conn, file_info, path, [range], options) do
  #   #   file_info(size: file_size) = file_info

  #   #   with %{"bytes" => bytes} <- Plug.Conn.Utils.params(range),
  #   #        {range_start, range_end} <- start_and_end(bytes, file_size) do
  #   #     send_range(conn, path, range_start, range_end, file_size, options)
  #   #   else
  #   #     _ -> send_entire_file(conn, path, options)
  #   #   end
  #   # end

  #   # defp serve_range(conn, _file_info, path, _range, options) do
  #   #   send_entire_file(conn, path, options)
  #   # end

  #   # defp start_and_end("-" <> rest, file_size) do
  #   #   case Integer.parse(rest) do
  #   #     {last, ""} when last > 0 and last <= file_size -> {file_size - last, file_size - 1}
  #   #     _ -> :error
  #   #   end
  #   # end

  #   # defp start_and_end(range, file_size) do
  #   #   case Integer.parse(range) do
  #   #     {first, "-"} when first >= 0 ->
  #   #       {first, file_size - 1}

  #   #     {first, "-" <> rest} when first >= 0 ->
  #   #       case Integer.parse(rest) do
  #   #         {last, ""} when last >= first -> {first, min(last, file_size - 1)}
  #   #         _ -> :error
  #   #       end

  #   #     _ ->
  #   #       :error
  #   #   end
  #   # end

  #   # defp send_range(conn, path, 0, range_end, file_size, options) when range_end == file_size - 1 do
  #   #   send_entire_file(conn, path, options)
  #   # end

  #   # defp send_range(conn, path, range_start, range_end, file_size, _options) do
  #   #   length = range_end - range_start + 1

  #   #   conn
  #   #   |> put_resp_header("content-range", "bytes #{range_start}-#{range_end}/#{file_size}")
  #   #   |> send_file(206, path, range_start, length)
  #   #   |> halt()
  #   # end

  #   # defp send_entire_file(conn, path, options) do
  #   #   conn
  #   #   |> maybe_add_vary(options)
  #   #   |> send_file(200, path)
  #   #   |> halt()
  #   # end

  #   defp maybe_add_encoding(conn, nil), do: conn
  #   defp maybe_add_encoding(conn, ce), do: put_resp_header(conn, "content-encoding", ce)

  #   defp maybe_add_vary(conn, %{gzip?: gzip?, brotli?: brotli?}) do
  #     # If we serve gzip or brotli at any moment, we need to set the proper vary
  #     # header regardless of whether we are serving gzip content right now.
  #     # See: http://www.fastly.com/blog/best-practices-for-using-the-vary-header/
  #     if gzip? or brotli? do
  #       update_in(conn.resp_headers, &[{"vary", "Accept-Encoding"} | &1])
  #     else
  #       conn
  #     end
  #   end

  #   # defp put_cache_header(
  #   #        %Conn{query_string: "vsn=" <> _} = conn,
  #   #        qs_cache,
  #   #        _et_cache,
  #   #        _et_generation,
  #   #        _file_info,
  #   #        _path
  #   #      )
  #   #      when is_binary(qs_cache) do
  #   #   {:stale, put_resp_header(conn, "cache-control", qs_cache)}
  #   # end

  #   # defp put_cache_header(conn, _qs_cache, et_cache, et_generation, file_info, path)
  #   #      when is_binary(et_cache) do
  #   #   etag = etag_for_path(file_info, et_generation, path)

  #   #   conn =
  #   #     conn
  #   #     |> put_resp_header("cache-control", et_cache)
  #   #     |> put_resp_header("etag", etag)

  #   #   if etag in get_req_header(conn, "if-none-match") do
  #   #     {:fresh, conn}
  #   #   else
  #   #     {:stale, conn}
  #   #   end
  #   # end

  #   # defp put_cache_header(conn, _, _, _, _, _) do
  #   #   {:stale, conn}
  #   # end

  #   # defp etag_for_path(file_info, et_generation, path) do
  #   #   case et_generation do
  #   #     {module, function, args} ->
  #   #       apply(module, function, [path | args])

  #   #     nil ->
  #   #       file_info(size: size, mtime: mtime) = file_info
  #   #       <<?", {size, mtime} |> :erlang.phash2() |> Integer.to_string(16)::binary, ?">>
  #   #   end
  #   # end

  #   defp file_encoding(conn, path, [_range], _gzip?, _brotli?) do
  #     # We do not support compression for range queries.
  #     file_encoding(conn, path, nil, false, false)
  #   end

  #   defp file_encoding(conn, path, _range, gzip?, brotli?) do
  #     cond do
  #       file_info = brotli? and accept_encoding?(conn, "br") && regular_file_info(path <> ".br") ->
  #         {"br", file_info, path <> ".br"}

  #       file_info = gzip? and accept_encoding?(conn, "gzip") && regular_file_info(path <> ".gz") ->
  #         {"gzip", file_info, path <> ".gz"}

  #       file_info = regular_file_info(path) ->
  #         {nil, file_info, path}

  #       true ->
  #         :error
  #     end
  #   end

  #   # defp regular_file_info(path) do
  #   #   case :prim_file.read_file_info(path) do
  #   #     {:ok, file_info(type: :regular) = file_info} ->
  #   #       file_info

  #   #     _ ->
  #   #       nil
  #   #   end
  #   # end

  #   defp accept_encoding?(conn, encoding) do
  #     encoding? = &String.contains?(&1, [encoding, "*"])

  #     Enum.any?(get_req_header(conn, "accept-encoding"), fn accept ->
  #       accept |> Plug.Conn.Utils.list() |> Enum.any?(encoding?)
  #     end)
  #   end

  #   defp merge_headers(conn, {module, function, args}) do
  #     merge_headers(conn, apply(module, function, [conn | args]))
  #   end

  #   defp merge_headers(conn, headers) do
  #     merge_resp_headers(conn, headers)
  #   end
end
