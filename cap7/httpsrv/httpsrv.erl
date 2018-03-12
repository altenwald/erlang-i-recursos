-module(httpsrv).
-export([start/1]).

-define(RESP, "HTTP/1.1 200 OK
Content-Length: 2
Content-Type: text/plain

OK").

start(Port) ->
    spawn(fun() -> srv_init(Port) end).

srv_init(Port) ->
    Opts = [{reuseaddr, true}, {active, false}, {packet, http}],
    {ok, Socket} = gen_tcp:listen(Port, Opts),
    srv_loop(Socket).

srv_loop(Socket) ->
    {ok, SockCli} = gen_tcp:accept(Socket),
    Pid = spawn(fun() -> worker_loop(SockCli) end),
    gen_tcp:controlling_process(SockCli, Pid),
    inet:setopts(SockCli, [{active, true}]),
    srv_loop(Socket).

worker_loop(Socket) ->
    receive
        {http, Socket, http_eoh} ->
            inet:setopts(Socket, [{packet, raw}]),
            worker_loop(Socket);
        {http, Socket, Header} ->
            io:format("Recibido ~p: ~p~n", [self(), Header]),
            worker_loop(Socket);
        {tcp, Socket, Msg} ->
            io:format("Recibido ~p: ~p~n", [self(), Msg]),
            gen_tcp:send(Socket, ?RESP),
            gen_tcp:close(Socket);
        {tcp_closed, Socket} ->
            io:format("Finalizado.~n"),
            gen_tcp:close(Socket);
        Any ->
            io:format("Mensaje no reconocido: ~p~n", [Any]),
            gen_tcp:close(Socket)
    end.