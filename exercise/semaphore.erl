-module (semaphore).
-compile ( export_all ).

make_semaphore ( Permits ) ->
    spawn(?MODULE , semaphore ,[ Permits ]).

semaphore(0) ->
    receive
	{From,release} -> 
	    From!{self(),ok},
	    semaphore(1)	
    end ;

semaphore(N) when N >0 ->
    receive
	{From , release } ->
	    From!{self(),ok},
	    semaphore(N+1);
	{From ,acquire } ->
	    From !{ self () ,ok},
	    semaphore (N -1)
    end .

client1(S) ->
    io:format("A~n"),
    S!{self(),acquire},
    receive
	{From,ok} ->
	    ok
    end,
    io:format("C~n").

client2(S) ->
    io:format("B~n"),
    S!{self(),acquire},
    receive
	{From,ok} ->
	    ok
    end,
     io:format("D~n").

test() ->
    S=make_semaphore(1),
    spawn(?MODULE , client1 ,[ S ]),
    spawn(?MODULE , client2 ,[ S ]).
