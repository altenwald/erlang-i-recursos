-module(escucha).
-compile([export_all]).

escucha() ->
    receive
        {Desde, Mensaje} ->
            io:format("recibido: ~p~n", [Mensaje]),
            Desde ! ok,
            escucha();
        stop ->
            io:format("proceso terminado~n")
    after 5000 ->
        io:format("dime algo!~n"),
        escucha()
    end.

para(Pid) ->
    Pid ! stop,
    ok.

dime(Pid, Algo) ->
    Pid ! {self(), Algo},
    receive
        ok -> ok
    end,
    ok.

init() ->
    spawn(escucha, escucha, []).