-module(mergesort).
-export([ordena/1]).

ordena([]) -> [];
ordena([H]) -> [H];
ordena(L) ->
    {L1,L2} = separa(L),
    mezcla(ordena(L1), ordena(L2)).

separa(L) ->
    lists:split(length(L) div 2, L).

mezcla([], L) -> L;
mezcla(L, []) -> L;
mezcla([H1|T1], [H2|_]=L2) when H1 =< H2 ->
    [H1|mezcla(T1,L2)];
mezcla(L1, [H2|T2]) ->
    [H2|mezcla(L1,T2)].

