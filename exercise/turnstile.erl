-module(turnstile).
-compile(export_all).

%% c(turnstile).
%% turnstile:test().

make_semaphore ( Permits ) ->
    spawn(?MODULE , semaphore ,[ Permits ]).

semaphore(0) ->
    receive
	{From,release} ->
	    From!{self(),ok},
	    semaphore(1)
    end;
semaphore(N) when N > 0 ->
    receive
	{From,acquire} ->
	    From!{self(),ok},
	    semaphore(N-1);
	{From,release} ->
	    From!{self,ok},
	    semaphore(N+1)
    end.
turnstile1(S,Count) when Count < 10 ->
    S!{self(),acquire},
    receive
	{From,ok}->
	    io:format("T1 pass,Count: ~p~n",[Count]),
	    S!{self(),release},
	    turnstile1(S,Count+1)
	end;
turnstile1(S,Count) ->io:format("T1 full~n").

turnstile2(S,Count) when Count < 10 ->
    S!{self(),acquire},
    receive
	{From,ok}->
	    io:format("T2 pass,Count: ~p~n",[Count]),
	    S!{self(),release},
	    turnstile2(S,Count+1)
	end;
turnstile2(S,Count) -> io:format("T2 full~n").

test() ->
    S = make_semaphore(1),
    spawn(?MODULE,turnstile1,[S,0]),
    spawn(?MODULE,turnstile2,[S,0]).
