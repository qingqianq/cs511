-module(basic).
-compile(export_all).

mult(Mult1,Mult2) ->
    Mult1 * Mult2.

double(Doublearg) ->
    2 * Doublearg.

distance({X1,Y1},{X2,Y2}) ->
    math:sqrt((Y2-Y1)*(Y2-Y1)+(X2-X1)*(X2-X1)).

my_or(A,B) when (A =:= true) ->
    A;
my_or(A,B) when (B =:= true) ->
    B;
my_or(A,B) -> false.

my_and(A,B) when (A=:=true),(B=:=true)->
    true;
my_and(A,B) ->false.

my_not(A) when (A=:=true) ->
    false;
my_not(A) -> true.


fi(1) -> 1;
fi(2) -> 2;
fi(N) -> fi(N-2) + fi(N - 1).
fibo(N) -> fibo(N,0,1).
fibo(0,P,Q) -> P ;
fibo(N,P,Q) -> fibo(N-1,Q,P+Q).

sum(L) -> sum(L,0).
sum([],N) -> N;
sum([H|T],N) -> sum(T,H+N).

maxnum([H|T]) -> maxnum(T,H).
maxnum([],Result) -> Result;
maxnum([H|T],Result) when H > Result -> maxnum(T,H); 
maxnum([H|T],Result) -> maxnum(T,Result).
    
reverse(L) -> reverse(L,[]).
reverse([H|T],M) -> reverse(T,[H|M]);
reverse([],M) -> M.


 %append(L1,[]) -> L1;
 %append([],L2) -> L2;
 %append(L1,[H|T]) ->
 %   Temp = list : append(L1,[H]).
 %   append(Temp,T).

%append(list1, list2) -> bas
%[list1, list2]
%C =append(A,B).
append([H|T], Tail) ->
    [H|append(T, Tail)];
append([], Tail) ->
    Tail.
myreverse([H|T]) when T == [] -> [H];
myreverse([H|T]) -> myreverse(T)++[H].

evenL([H|T]) -> evenL([H|T],[]).
evenL([H|T],M) when H rem 2 /= 0 -> evenL(T,[H|M]);
evenL([H|T],M) -> evenL(T,M);
evenL([],M) -> M.


take(0,[H|T],M) -> M;
take(N,[H|T],M) -> take(N-1,T,M++H).

drop(0,[H|T]) -> [H|T];
drop(N,[H|T]) -> drop(N-1,T).
    
map(Fun,[H|T]) -> map(Fun,[H|T],[]).
map(Fun,[],M) -> M;
map(Fun,[H|T],M) -> [Fun(H)]++M.

-spec mymap(fun(),list())->list().
mymap(Fun,[]) -> [];
mymap(Fun,[H|T]) -> mymap(Fun,[H|T],[]).
mymap(Fun,[],M) -> M;
mymap(Fun,[H|T],M) -> mymap(Fun,T,M++[Fun(H)]).

