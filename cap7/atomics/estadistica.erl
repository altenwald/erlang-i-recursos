-module(estadistica).
-export([inicio/0, anota/2, muestra/1]).

inicio() ->
    {
        atomics:new(24, [{signed, false}]),
        atomics:new(24, [{signed, false}])
    }.

anota({RefSum, RefCont}, Duracion) ->
    {Hora, _, _} = time(),
    ok = atomics:add(RefSum, Hora + 1, Duracion),
    ok = atomics:add(RefCont, Hora + 1, 1),
    ok.

muestra({RefSum, RefCont}) ->
    lists:map(fun(Hora) ->
        case atomics:get(RefCont, Hora) of
            0 -> 0;
            Cont -> atomics:get(RefSum, Hora) / Cont
        end
    end, lists:seq(1, 24)).