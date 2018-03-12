-module(gemelos).
-compile([export_all]).

lanza() ->
    spawn(gemelos, crea, []),
    ok.

crea() -> 
    spawn_link(gemelos, zipi, [0]),
    timer:sleep(500),
    zape(0).

zipi(A) ->
    io:format("zipi - ~w~n", [A]),
    timer:sleep(1000),
    zipi(A+1).

zape(A) ->
    io:format("zape - ~w~n", [A]),
    timer:sleep(1000),
    case A of
      A when A < 5 -> ok
    end,
    zape(A+1).