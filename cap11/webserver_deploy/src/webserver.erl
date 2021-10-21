-module(webserver).
-export([start/1]).

start(Port) ->
    spawn(fun() -> srv_init(Port) end).

srv_init(Port) ->
    Opts = [{reuseaddr, true}, {active, false}, {packet, http}],
    {ok, Socket} = gen_tcp:listen(Port, Opts),
    srv_loop(Socket).

srv_loop(Socket) ->
    {ok, SockCli} = gen_tcp:accept(Socket),
    Pid = spawn(fun() -> worker_loop(SockCli, []) end),
    gen_tcp:controlling_process(SockCli, Pid),
    inet:setopts(SockCli, [{active, true}]),
    srv_loop(Socket).

worker_loop(Socket, State) ->
    receive
        {http, Socket, {http_request, Method, TPath, _}} ->
            {abs_path, Path} = TPath,
            error_logger:info_msg("Request: ~p~n", [Path]),
            worker_loop(Socket, State ++ [
                {method, Method}, {path, Path}
            ]);
        {http, Socket, {http_header, _, Key, _, Value}} ->
            worker_loop(Socket, State ++ [{Key, Value}]);
        {http, Socket, http_eoh} ->
            Response = fileserver:send(State),
            gen_tcp:send(Socket, Response),
            gen_tcp:close(Socket);
        {tcp_closed, Socket} ->
            error_logger:info_msg("End.~n"),
            gen_tcp:close(Socket);
        Any ->
            error_logger:info_msg("Unknown: ~p~n", [Any]),
            gen_tcp:close(Socket)
    end.