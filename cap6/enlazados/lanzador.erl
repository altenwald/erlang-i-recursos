-module(lanzador).
-compile([export_all]).

init() ->
    spawn(lanzador, loop, []).

loop() ->
    receive
        {link, Pid} ->
            link(Pid);
        error ->
            throw(error)
    end,
    loop().

agrega(Lanzador, Pid) ->
    Lanzador ! {link, Pid},
    ok.