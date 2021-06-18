-module(fact).
-compile(export_all).

fact(0) -> 1;
fact(N) -> N * fact(N - 1).