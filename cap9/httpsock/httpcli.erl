-module(httpcli).

-export([http_request/2]).

http_request(Port, URI) ->
    {ok, Socket} = socket:open(inet, stream, tcp),
    ok = socket:connect(Socket, #{
        family => inet,
        addr => {127,0,0,1},
        port => Port
    }),
    Msg = "GET " ++ URI ++ " HTTP/1.1\r\n"
          "Host: localhost\r\n\r\n",
    ok = socket:send(Socket, Msg),
    ok = socket:shutdown(Socket, write),
    {ok, Response} = socket:recv(Socket),
    ok = socket:close(Socket),
    Response.