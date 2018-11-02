-module(echo).
-compile(export_all).

echo() ->
    receive
	{From,Msg} ->
	    From!{self(),Msg},
	    echo();
	stop -> true
end.

start() ->
    Pid = spawn(fun echo/0),
    Token = "hello server!",
    Pid!{self(),Token},
    io:format("sent ~s~n",[Token]),
    receive
	{Pid,Msg} ->
	    io:format("Received ~s~n",[Msg])
    end,
    Pid! stop.
echo2() ->
    receive
	{From,Msg} ->
	    timer: sleep(rand:uniform(100)),
	    From ! {Msg},
	    echo2();
	stop -> true
		    end.
start2() ->
    PidB = spawn(fun echo2/0),
    PidC = spawn(fun echo2/0),
    Token = 42,
    PidB !{self(),Token},
    io:format("send ~w~n",[Token]),
    Token2 = 41,
    PidC!{self(),Token2},
    receive
	{Msg} ->
	    io:format("Received",Msg)
    end,
    PidB !stop,
    PidC!stop.
