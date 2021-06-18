-module(traductor).
-export([get/1]).
-import(proplists, [get_value/2]).

data() ->
    [{"hi", "hola"}, {"bye", "adios"}].

get(Key) ->
    get_value(Key, data()).