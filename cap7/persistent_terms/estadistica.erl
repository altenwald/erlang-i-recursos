-module(estadistica).
-export([inicio/1, anota/2, muestra/1]).

inicio(Key) ->
    Sum = atomics:new(24, [{signed, false}]),
    Cont = counters:new(24, [write_concurrency]),
    persistent_term:put(Key, {Sum, Cont}).

anota(Key, Duracion) ->
    {Hora, _, _} = time(),
    {RefSum, RefCont} = persistent_term:get(Key),
    ok = atomics:add(RefSum, Hora + 1, Duracion),
    ok = counters:add(RefCont, Hora + 1, 1),
    ok.

muestra(Key) ->
    {RefSum, RefCont} = persistent_term:get(Key),
    lists:map(fun(Hora) ->
        case counters:get(RefCont, Hora) of
            0 -> 0;
            Cont -> atomics:get(RefSum, Hora) / Cont
        end
    end, lists:seq(1, 24)).