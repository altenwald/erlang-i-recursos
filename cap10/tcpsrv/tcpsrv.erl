-module(tcpsrv).
-export([start/1]).

start(Port) ->
    spawn_link(fun() -> srv_init(Port) end).

srv_init(Port) ->
    Opts = [
        {reuseaddr, true},
        {active, false},
        {certfile, "cert.pem"},
        {keyfile, "key.pem"}
    ],
    {ok, Socket} = ssl:listen(Port, Opts),
    srv_loop(Socket).

srv_loop(Socket) ->
    {ok, TLSTransportSock} = ssl:transport_accept(Socket),
    {ok, SockCli} = ssl:handshake(TLSTransportSock),
    Pid = spawn_link(fun() -> worker_loop(SockCli) end),
    ssl:controlling_process(SockCli, Pid),
    ssl:setopts(SockCli, [{active, true}]),
    srv_loop(Socket).

worker_loop(Socket) ->
    receive
        {ssl, Socket, Msg} ->
            io:format("Recibido ~p: ~p~n", [self(), Msg]),
            Salida = io_lib:format("Eco: ~s", [Msg]),
            ssl:send(Socket, Salida),
            worker_loop(Socket);
        {ssl_closed, Socket} ->
            io:format("Finalizado.~n");
        Any ->
            io:format("Mensaje no reconocido: ~p~n", [Any])
    end.
