-module(ticket).
-compile(export_all).

start()->
    L = [spawn(?MODULE,client,[]) || _<-lists:seq(1,10)],
    spawn(?MODULE,timer,[1000,L]).

client()->
    receive
	{From,ticket} ->
	    io:format("~p received tickets~n",[self()]),
	    ok
    end.

timer(Time,[]) -> done;
timer(Time,[H|T])  ->
    timer:sleep(Time),
    H!{self(),ticket},
    timer(Time,T).



