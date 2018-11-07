-module(sensor).
-compile(export_all).
-author("Guangqiqing,Bingyingchen").

sensor(Watcher,SenserId) ->
    Measurement = rand:uniform(11),
    if
	Measurement == 11 -> 
	    Watcher!{'EXIT',self(),SenserId,anomalous_reading},   % Crash statemnt
	    io:format("there is a crash, crashId : ~p~n",[SenserId]),
	    exit(anomalous_reading); 
	true -> 
	    Watcher!{self(),SenserId, Measurement}
    end,
    receive
	{sleep}->
            timer:sleep(rand:uniform(1000)),
            sensor(Watcher,SenserId)
    end.
