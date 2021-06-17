-module(fact2).
-compile(export_all).

fact(N) -> fact(N, 1).

fact(0, Result) -> Result;
fact(N, Result) -> fact(N - 1, Result * N).