-module(hash).
-export([init/1, get/2, set/3]).

get(Pid, Key) ->
    Pid ! {get, self(), Key},
    receive 
        Any -> Any 
    end.

set(Pid, Key, Value) ->
    Pid ! {set, Key, Value},
    ok.

init(Node) ->
    io:format("iniciado~n"),
    spawn(Node, fun() -> 
        loop([{"hi", "hola"}, {"bye", "adios"}]) 
    end).

loop(Data) ->
    receive
        {get, From, Key} -> 
            Val = proplists:get_value(Key, Data),
            From ! Val,
            loop(Data);
        {set, Key, Value} ->
            loop([{Key, Value}|Data]);
        stop ->
            ok
    end.