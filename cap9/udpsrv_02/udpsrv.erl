-module(udpsrv).
-export([start/1, init/1, loop/1]).

-record(udp, {socket, ip, port, msg}).

start(Port) ->
    spawn(?MODULE, init, [Port]),
    ok.

init(Port) ->
    {ok, Socket} = gen_udp:open(Port),
    loop(Socket).

loop(Socket) ->
    receive
        stop ->
            gen_udp:close(Socket);
        Packet when is_record(Packet, udp) ->
            io:format("recibido(~p): ~p~n", [
                Packet#udp.ip, Packet#udp.msg
            ]),
            #udp{ip=IP,port=Port} = Packet,
            gen_udp:send(Socket, IP, Port, "recibido"),
            loop(Socket)
    end.