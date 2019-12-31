%% $Id$
%% $Author$ Louis Frayser <Earthlink.NET!frayser>
%% $Source$
%%
%% $Log$
:- module(lambda, 
	[ flip/1
	, take/3,subtract_list/3
	, odd/1,even/1
	, replicate/3
	, scanl/4, scanl1/3
	, odd/1
	, even/1
]).

line(Aline, In,Rest):-
	(
	    In==[]
	->  Aline=[], Rest=[]
	;
	    In=['\r'|In1]
	->  line(Aline,In1,Rest)
	;
	    In=['\n'|Rest]
	->  Aline = []
	;
	    true
	->  Aline=[C|Xs], In=[C|Rest1], line(Xs, Rest1,Rest)
	).


not_p(P,X):-
	\+ call(P,X).

chr(Code,Char) :-
	char_code(Char,Code).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LISTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% replicate ::  Int -> a -> [a]
replicate(0,_,[]).
replicate(N,Obj,[Obj|Rest_objs]) :-
	One_less is N - 1,
	replicate(One_less,Obj, Rest_objs).

%% ---------------------------------------------------------------
%%% Scans
%%% Example scanl1(plus, [1,1,1,1],Ans) => Ans = [1,2,3,4].
%% scanl :: (a -> b -> a) -> a -> [b] -> [a]
scanRest(_,_,[],[]).
scanRest(F,Z,[X|Xs], Ans) :-
        apply(F,[Z,X,A1]),
        scanl(F, A1, Xs,Ans).

scanl(F, Z, Xs, [Z|Rest]):-
        scanRest(F, Z, Xs,Rest).
        
%% scanl1 :: (a -> a -> a) -> [a] -> [a]
scanl1(_,[], []).
scanl1(F, [X|Xs],Ans):-
        scanl(F,X,Xs,Ans).
%%% ................................................................
%%% Like subtract for sets; but for list
%%% Subtracts each element in 2nd list, once, from 1st list.
subtract_list(L,[S|Ss],Ans):-
	select(S,L,L1),
	subtract_list(L1,Ss,Ans).
subtract_list(L,[],L).

take(0,_ , []) :-!.
take(_,[], []) :-!.
take(N,[H|T],[H|Result]) :-
	N1 is N - 1,
	take(N1,T,Result).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
flip(Goal) :-
	Goal =.. [P,X,Y],
	call(P,Y,X).
flip(Goal) :-
	Goal =.. [P,X,Y,Result],
	call(P,Y,X,Result).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Numbers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

even(X) :-
	0 is X mod 2.

odd(X) :-
	\+ even(X).


