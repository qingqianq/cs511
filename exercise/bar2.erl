-module(bar2).
-compile(export_all).

start(W,M) ->
    S = spawn(?MODULE,server,[0,0,false]),

    [spawn(?MODULE,woman,[S]) || _<- lists:seq(1,W)],
    [spawn(?MODULE,man,[S]) || _<-lists:seq(1,M)],
    spawn(?MODULE,itGotLate,[1000,S]).
itGotLate(Time,S) ->
    timer:sleep(Time),
    R = make_ref(),
    S!{self(),R,itGotLate},
    receive
	{S,R,ok} ->
	    ok
    end.

woman(S) ->
    S!{self(),woman}.
man(S) ->
    Ref = make_ref(),
    S!{self(),Ref,man},
    receive 
	{S,Ref,ok} ->
	    io:format("man in~n")
    end.

server(Women,Men,Flag) -> %build a list to store the Pid of man 
    case Flag of
	false ->
	    receive
		{From,Ref,itGotLate} ->
		    From!{self(),Ref,ok},
		    io:format("gotLate~n"),
		    flush_men_request(),
		    server(Women,Men,true);
		{From, woman} ->
		    io:format("woman comes ~n"),
		    server(Women + 1, Men, false);

		{From,Ref,man} when Women > 1 ->  
		    From!{self(),Ref,ok},
		    server(Women - 2, Men, false)
	    end;
	true ->
	    io:fromat("1111111111"),
	    receive
		{From,woman} ->
		    server(Women + 1,Men,true);
		{From,Ref,man} -> 
		    From!{self(),Ref,ok},
		    server(Women,Men+1,true)
	    end
    end.

flush_men_request()->
    receive
	{From,Ref,man} ->
	    From!{self(),Ref,ok},
	    flush_men_request()
    after 0 ->
	    ok
    end.
