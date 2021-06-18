-module(monitor).
-export([init/0, agrega/2]).

init() ->
    Pid = spawn(fun() -> loop([]) end),
    register(monitor, Pid),
    ok.

loop(State) ->
    receive
        {monitor, From, Name, Fun} ->
            Pid = lanza(Name, Fun),
            From ! {ok, Name},
            loop([{Pid,[Name, Fun]}|State]);
        {'DOWN',_Ref,process,Pid,_Reason} ->
            [Name, Fun] = proplists:get_value(Pid, State),
            NewPid = lanza(Name, Fun),
            io:format("reavivando hijo en ~p~n", [NewPid]),
            AntiguoHijo = {Pid,[Name,Fun]},
            NuevoHijo = {NewPid,[Name,Fun]},
            loop([NuevoHijo|State] -- [AntiguoHijo])
    end.

lanza(Name, Fun) ->
    Pid = spawn(Fun),
    register(Name, Pid),
    monitor(process, Pid),
    Pid.

agrega(Name, Fun) ->
    monitor ! {monitor, self(), Name, Fun},
    receive {ok, Pid} -> Pid end.