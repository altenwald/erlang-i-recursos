-module(clausura).
-compile([export_all]).

multiplicador(X) when is_integer(X) ->
    fun(Y) -> X * Y end.