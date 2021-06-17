-module(escucha_alias).
-export([escucha/0, para/1, dime/3, init/0, espera/2]).

escucha() ->
    receive
        {bloqueado, Tiempo} ->
            timer:sleep(Tiempo),
            escucha();
        {Desde, Mensaje} ->
            Desde ! {ok, Desde, Mensaje},
            escucha();
        stop ->
            io:format("proceso terminado~n")
    after 5_000 ->
        io:format("dime algo!~n"),
        ?MODULE:escucha()
    end.

para(Pid) ->
    Pid ! stop,
    ok.

espera(Pid, Tiempo) ->
    Pid ! {bloqueado, Tiempo},
    ok.

dime(Pid, Algo, Espera) ->
    Alias = alias(),
    Pid ! {Alias, Algo},
    receive
        {ok, Desde, Mensaje} ->
            Args = [Desde, self(), Mensaje],
            io:format("De ~p para ~p: ~p~n", Args)
    after Espera ->
        unalias(Alias),
        {error, timeout}
    end.

init() ->
    spawn(?MODULE, escucha, []).