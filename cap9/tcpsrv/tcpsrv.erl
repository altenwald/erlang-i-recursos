-module(tcpsrv).
-export([start/1]).

start(Port) ->
    spawn(fun() -> srv_init(Port) end).

srv_init(Port) ->
    Opts = [{reuseaddr, true}, {active, false}],
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
        {tcp, Socket, Msg} ->
            io:format("Recibido ~p: ~p~n", [self(), Msg]),
            timer:sleep(5000), %% 5 segundos de espera
            gen_tcp:send(Socket, io_lib:format("Eco: ~s", [Msg])),
            worker_loop(Socket);
        {tcp_closed, Socket} ->
            io:format("Finalizado.~n");
        Any ->
            io:format("Mensaje no reconocido: ~p~n", [Any])
    end.