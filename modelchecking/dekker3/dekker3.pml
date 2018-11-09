byte turn = 0;
bool flag[3];
proctype P(){
	byte myId = _pid - 1;
	byte left = myId % 3;
	byte right = (myId + 2) % 3;

	do
		:: (flag[left] == true) || (flag[right] == true) ->
		if 
			:: (turn == left) -> 
				flag[myId] = false;
				if
				:: (turn == myId) ->
				flag[myId] = true
				fi
		fi
		:: else ->
	od;
	turn = right;
	flag[myId] = false

}
init{
	turn = 0;
	byte i;
	for(i :0..2){
		flag[i] = false;
	}
	atomic{
		for(i :0..2){
			run P()
		}
	}
}