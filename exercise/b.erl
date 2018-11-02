-module(b).
-compile(export_all).
%% C-c C-k
startb(N) ->
    Pid = spawn(fun() -> coordinator(N,N,[])  end),
    register(coordinator,Pid).
startc()->
    startb(3),
    spawn(?MODULE,client,["a~n","b~n"]),
    spawn(?MODULE,client,["c~n","d~n"]),
    spawn(?MODULE,client,["e~n","f~n"]).



coordinator(0,N,L) ->
    [From!{self(),Ref,ok} || {From,Ref}<-L],
    coordinator(N,N,[]);
coordinator(M,N,L) when M>0 ->
    receive
	{From,Ref,arrived}->
	    NewList = lists:append(L,[{From,Ref}]),
	    coordinator(M-1,N,NewList)
	    %%coordinator(M-1,N,[{From,Ref}|L])

    end.

client(Str1,Str2) ->
    io:format(Str1,[]),
    Ref = make_ref(),
    C = whereis(coordinator),
    coordinator!{self(f),Ref,arrived},
    receive
	{C,Ref,ok} ->
	    ok
    end,
    io:format(Str2,[]),
    done.
