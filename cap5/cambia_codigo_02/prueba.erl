-module(prueba).
-export([code_change/0]).

code_change() ->
    loop().

loop() ->
    receive
        update ->
            code:purge(?MODULE),
            code:load_file(?MODULE),
            ?MODULE:code_change();
        Any ->
            io:format("original: ~p~n", [Any]),
            loop()
    end.