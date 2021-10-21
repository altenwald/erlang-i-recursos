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

send(Request) ->
    "/" ++ Path = proplists:get_value(path, Request, "/"),
    {ok, CWD} = file:get_cwd(),
    RealPath = filename:join(CWD, Path),
    case file:read_file(RealPath) of
        {ok, Content} ->
            Size = list_to_binary(
                io_lib:format("~p", [byte_size(Content)])
            ),
            [Type] = mimetypes:filename(Path),
            <<
                ?RESP_200/binary, Type/binary,
                "\nContent-length: ", Size/binary,
                "\r\n\r\n", Content/binary
            >>;
        {error, _} ->
            ?RESP_404
    end.