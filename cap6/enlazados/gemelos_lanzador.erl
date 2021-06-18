-module(gemelos_lanzador).
-compile([export_all]).

lanza() ->
    LanzadorPid = lanzador:init(),
    Zipi = spawn(gemelos_lanzador, zipi, [0]),
    lanzador:agrega(LanzadorPid, Zipi),
    timer:sleep(500),
    Zape = spawn(gemelos_lanzador, zape, [0]),
    lanzador:agrega(LanzadorPid, Zape),
    LanzadorPid.

zipi(A) ->
    io:format("zipi - ~w~n", [A]),
    timer:sleep(1000),
    zipi(A+1).

zape(A) ->
    io:format("zape - ~w~n", [A]),
    timer:sleep(1000),
    zape(A+1).