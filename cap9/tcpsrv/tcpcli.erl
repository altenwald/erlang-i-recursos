-module(tcpcli).
-export([cli_send/2, cli_concurrent_send/1]).

cli_send(Port, Msg) ->
    Opts = [{active, true}],
    {ok, Socket} = gen_tcp:connect({127,0,0,1}, Port, Opts),
    gen_tcp:send(Socket, Msg),
    receive
        {tcp, Socket, MsgSrv} ->
            io:format("Retornado ~p: ~p~n", [self(), MsgSrv]);
        Any ->
            io:format("Mensaje no reconocido: ~p~n", [Any])
    end,
    gen_tcp:close(Socket).

cli_concurrent_send(Port) ->
    Send = fun(I) ->
        Text = io_lib:format("i=~p", [I]),
        spawn(tcpcli, cli_send, [Port, Text])
    end,
    lists:foreach(Send, lists:seq(1,10)).