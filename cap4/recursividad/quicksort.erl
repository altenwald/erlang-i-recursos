-module(quicksort).
-export([ordena/1]).

separa([]) ->
    {[], [], []};
separa([H]) ->
    {[H], [], []};
separa([Pivote|T]) ->
    Menor = [ X || X <- T, X =< Pivote ],
    Mayor = [ X || X <- T, X > Pivote ],
    {Menor, [Pivote], Mayor}.

mezcla(L1, L2) ->
    L1 ++ L2.

ordena([]) ->
    [];
ordena([H]) ->
    [H];
ordena(L) ->
    {L1, [Pivote], L2} = separa(L),
    mezcla(ordena(L1) ++ [Pivote], ordena(L2)).