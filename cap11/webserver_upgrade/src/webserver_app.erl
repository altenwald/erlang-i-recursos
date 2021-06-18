-module(webserver_app).
-behaviour(application).

-export([start/0, start/2, stop/1]).

start() ->
    application:start(webserver).

start(_StartType, _StartArgs) ->
    {ok, webserver:start(8888)}.

stop(_State) ->
    ok.
