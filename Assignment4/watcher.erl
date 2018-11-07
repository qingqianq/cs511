-module(watcher).
-compile(export_all).
-author("Guangqiqing,Bingyingchen").
						%c(watcher).
						%watcher:watcher(50).

restarter()->
    process_flag(trap_exit,true),
    Pid = spawn_link(sensor,sensor,[]),
    register(sensor,Pid),
    receive
	{'EXIT',Pid,normal} -> ok;
	{'EXIT',Pid,shutdown} -> ok;
	{'EXIT',Pid,_} -> restarter()
    end.

watcher(Num) -> createwatcherlist(Num,[],0).


createwatcherlist(Num,List,Id) when Num == 0 ->
    startWatch(List);
createwatcherlist(Num,List,Id) when length(List) == 10 ->  
						%  io:format("Num ~p",[Num]),
    spawn(?MODULE,createwatcherlist,[Num,[],Id]),
						%if full create new spawn to  open new 10 senser.
						%io:format("Num ~p~n",[Num]), 
						%io:format("length: ~p",[length(List)]),
    startWatch(List);
createwatcherlist(Num,List,Id) -> 
    {SensorPid,_} = spawn_monitor(sensor,sensor,[self(),Id]), 
						% create sensor by watcher, if full create a new process
						%io:format("SenPid:::~p~n",[SensorPid]),
    NewList = lists:append(List,[{Id,SensorPid}]),
						%io:format("~p",[length(List)]),
						% io:format(" ~p --- ~n",[NewList]),
    createwatcherlist(Num - 1,NewList,Id+1).

startWatch(List) ->
    io:fwrite("initial Watcher ~n~p~n~n",[List]),
    process_flag(trap_exit,true),
    receive
	{From,Sid,Measurement} ->
	    io:format("id: ~w, Measurement:~w~n ",[Sid,Measurement]),
	    From!{sleep},
	    startWatch(List);

	{'EXIT',From,Sid,anomalous_reading}  ->
	    %io:format("~n----------Id : ~p crashed~n~n",[Sid]),
	    NewList = lists:delete({Sid,From},List),
	    io:format("~n----------Id:~p restarted ~n~n",[Sid]),
	    {SensorPid,_} = spawn_monitor(sensor,sensor,[self(),Sid]),
	    startWatch(lists:append([{Sid,SensorPid}],NewList));
	{'DOWN',_,process,Pid,Reason} ->
	    io:format("~w end,Reason: ~w~n ~n",[Pid,Reason]),
	    startWatch(List)
    end.

start()->
    {ok, [ N ]} = io:fread("enter number of sensors> ", "~d"),
    if N =< 1 -> 
            io:fwrite("setup: range must be at least 2~n",[]);
       true ->
            watcher(N)
    end.
