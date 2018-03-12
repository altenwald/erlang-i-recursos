-module(fact).
-compile(export_all).

fact(0) -> 1;
fact(X) -> X * fact(X-1).