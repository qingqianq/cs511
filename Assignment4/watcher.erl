-module(watcher).
-compile(export_all).
-author("Guangqiqing").

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
    [io:format("Id:~w, Sensorpid:~w~n",[Id,SensorPid])||{Id,SensorPid}<-List],
    startWatch(List);
createwatcherlist(Num,List,Id) when length(List) == 10 ->  
						%  io:format("Num ~p",[Num]),
    [io:format("Id:~w, Sensorpid:~w~n",[Sid,SensorPid])||{Sid,SensorPid}<-List],
    spawn(?MODULE,createwatcherlist,[Num,[],Id]),
						%io:format("Num ~p~n",[Num]),
						%io:format("length: ~p",[length(List)]),
    io:format("----------------------~n"),
    startWatch(List);
createwatcherlist(Num,List,Id) -> 
    {SensorPid,_} = spawn_monitor(sensor,sensor,[self(),Id]), %create sensor  
    NewList = lists:append(List,[{Id,SensorPid}]),
						%io:format("~p",[length(List)]),
						% io:format(" ~p --- ~n",[NewList]),
    createwatcherlist(Num - 1,NewList,Id+1).

startWatch(List) ->
    ok.
