-module(ets_show).
-compile([export_all]).

show_all(Ets) ->
    show_all(Ets, ets:first(Ets), []).

show_all(_Ets, '$end_of_table', List) ->
    List;
show_all(Ets, Id, List) ->
    show_all(Ets,ets:next(Ets,Id),ets:lookup(Ets,Id) ++ List).

main() ->
    ets:new(bolsa, [named_table, bag]),
    Colores = [{rojo,255,0,0},{verde,0,255,0},{azul,0,0,255}],
    ets:insert(bolsa, Colores),
    show_all(bolsa).