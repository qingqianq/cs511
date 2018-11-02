-module(lib_misc).
-compile(export_all).
%-export([sum/1]).

sum(L) -> sum(L, 0).
sum([], N)    -> N;
sum([H|T], N) -> sum(T, H+N).

max(X, Y) when X > Y -> X;
max(X, Y) -> Y.

is_cat(A) when is_atom(A), A=:=cat ->
    true;
is_cat(A) -> false.

sum([L]) -> sum(L,0).
sum([],N) -> N;
sum([H|T],N) -> sum(T,H+N).