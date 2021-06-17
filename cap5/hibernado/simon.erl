-module(simon).
-export([init/0, dice/1, bucle/0]).

init() ->
    register(?MODULE, spawn(?MODULE, bucle, [])).

dice(Msg) ->
    ?MODULE ! Msg.

bucle() ->
    receive
        Msg ->
            io:format("Simón dice: ~p~n", [Msg]),
            ?MODULE:bucle()
    after 1_000 ->
        io:format("hibernando~n"),
        erlang:hibernate(?MODULE, bucle, [])
    end.