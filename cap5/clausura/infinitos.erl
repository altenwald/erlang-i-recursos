-module(infinitos).
-compile([export_all]).

enteros(Desde) ->
    fun() -> 
        [Desde|enteros(Desde+1)] 
    end.