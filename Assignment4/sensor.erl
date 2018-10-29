-module(sensor).
-compile(export_all).
-author("Guangqiqing").

sensor(Watcher,SenserId) ->
    Measurement = rand:uniform(11),
    if
	Measurement == 11 -> 
						% Crash statemnt
	    exit(anomalous_reading);
	true -> 
	    Watcher!{SenserId, Measurement}
    end,
    receive
	{_}->
	    timer:sleep(rand:uniform(10000))
    end.

