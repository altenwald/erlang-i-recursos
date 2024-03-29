-module(fileserver).
-export([send/1]).

-define(RESP_404, <<"HTTP/1.1 404 Not Found
Server: Erlang Web Server
Connection: Close

">>).

-define(RESP_200, <<"HTTP/1.1 200 OK
Server: Erlang Web Server
Connection: Close
Content-type: ">>).

-define(HELP_TEXT, <<"Texto de ayuda!">>).

send(Request) ->
    case proplists:get_value(path, Request, "/") of
        "/help" ->
            Content = ?HELP_TEXT,
            Size = list_to_binary(
                integer_to_list(byte_size(Content))
            ),
            <<
                ?RESP_200/binary, "text/html",
                "\nContent-length: ", Size/binary,
                "\n\n", Content/binary
            >>;
        "/" ++ Path ->
            {ok, CWD} = file:get_cwd(),
            RealPath = filename:join(CWD, Path),
            case file:read_file(RealPath) of
                {ok, Content} ->
                    Size = list_to_binary(
                        integer_to_list(byte_size(Content))
                    ),
                    Type = mimetype(Path),
                    <<
                        ?RESP_200/binary, Type/binary,
                        "\nContent-length: ", Size/binary,
                        "\n\n", Content/binary
                    >>;
                {error, _} ->
                    ?RESP_404
            end
    end.

mimetype(File) ->
    case filename:extension(string:to_lower(File)) of
        ".png" -> <<"image/png">>;
        ".jpg" -> <<"image/jpeg">>;
        ".jpeg" -> <<"image/jpeg">>;
        ".zip" -> <<"application/zip">>;
        ".xml" -> <<"application/xml">>;
        ".css" -> <<"text/css">>;
        ".html" -> <<"text/html">>;
        ".htm" -> <<"text/html">>;
        ".js" -> <<"application/javascript">>;
        ".ico" -> <<"image/vnd.microsoft.icon">>;
        _ -> <<"text/plain">>
    end.
