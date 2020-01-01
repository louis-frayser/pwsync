:- module(list, [ckdups/1,ckdups/2,concat/2,intercalate/3, break/3
		, max/3, min/3
		, span/3
		, lines/2,unlines/2]).

:- dynamic
	user:goal_expansion/2.
:- multifile
	user:goal_expansion/2.
user:goal_expansion(elem(E,L), memberchk(E,L)).

ckdups([],_).
ckdups([_],_).
ckdups([X,Y|Rest],Compare) :-
		( call( Compare, =,X,Y)
		-> writeln(dups(X,Y))
		; true
		),
		 ckdups([Y|Rest],Compare).

ckdups(L) :-
		L = []
		-> true
		; L = [_] -> true
		; ckdups(L, compare).


		
%%% concat :: [[a]] -> [a]
%% FIXME: Make work for atoms and strings and any list type.
concat(XS,Out):-
	concat_atom(XS,Out).


intercalate(Sep,List,Out):-
	(
		List='' -> Out=''
	;
		List=[X] -> Out=X
	;
		List=[X,Y] -> concat([X,Sep,Y],Out)
	;
		List = [H|T]
	->	intercalate(Sep, T,Out1),
		concat([H,Sep,Out1],Out)
	).
	   
	 
%%%
%%%  Breaks a list of chars on the '\n' characters into a list of list of chars 
%%%  where each sublist represents a line of text.
lines([],[]).
lines([L|Ls],Buf):-
	line(L,Buf,Rest),
	lines(Ls,Rest).

%%% List of Strings -> String Buffer w/ newlines.
unlines(List,Buf) :-
	intercalate('\n',List,Buf).

%%% FIXME: Test for '\r' in DoS stylee
line([],[],[]).
line(Line,Buf_in,Diff) :-
	(	Buf_in = [] 
	->	Line = [], Diff = []
	;	
		Buf_in = ['\n'|T]
	->	Line = [], Diff = T
	;
		Buf_in = [C|T],
		line(Cs,T,Diff),
		Line = [C|Cs]
	).

%% SWI now includes foldl.
%% Use fold instead of reduce. (foldl, foldr in Haskell, reduce in lisp)


/* From Curry
--- (span p xs) is equivalent to (takeWhile p xs, dropWhile p xs)
span               :: (a -> Bool) -> [a] -> ([a],[a])
span _ []          = ([],[])
span p (x:xs)
  | p x	      = let (ys,zs) = span p xs in (x:ys,zs)
  | otherwise = ([],x:xs)
*/
span([]-[],_Pred,[]).
span(O1-O2,Pred,[X|Xs]) :-
	(
	    call(Pred,X)
	->  span(Ys-Zs,Pred,Xs), O1=[X|Ys], O2=Zs
	;
	    otherwise
	->  O1=[], O2=[X|Xs]
	    
	).

break([]-[],_Pred,[]).
break(O1-O2,Pred,[X|Xs]) :-
	(
	    \+ call(Pred,X)
	->  break(Ys-Zs,Pred,Xs), O1=[X|Ys], O2=Zs
	;
	    otherwise
	->  O1=[], O2=[X|Xs]
	    
	).

min(X,Y,Min) :- Min is min(X,Y).
max(X,Y,Max) :- Max is max(X,Y).

user:goal_expansion(minimum(L,M),min_list(L,M)).
user:goal_expansion(maximum(L,M),max_list(L,M)).



/*
words([],[]).
words([' '|T],Ws) :- words(T,Ws).
words([H,Ws) :- H \= ' ',
      take_wchars(Ws,Cs,Rest),
      words(Rest,[[H|Cs],Ws]

*/


