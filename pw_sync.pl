%-*-prolog-*-
library_directory("library").
:- use_module(report).
:- use_module(pw_file).
:- use_module([library(lambda), library(list)]).

%%% 1. Lookup each entry of Control in UUT and classify as missing of incorrect.
%%%    Return the unmatched items from both sets.
%%%    categorize(UUT,Control,Missing,Incorrect).
%%%    Incorrect=[incorrect(uid,udt(..),control(..)..]
%%%    Missing=[missing(...), ...]
%%%
pw_sync(UUT,Control,Missing,Incorrect):-
	categorize(UUT,Control, Missing,Incorrect).

%%% Categorize items in the UUT as either missing or inconflict with the
%%% control. We use the the partition' function, so classify needs to return
%%% <, > or =.  Our convention is '< for Missing and '>' for incorrect.
%%% Correct items are mapped to '='.
%%% 'Classify' will be ba lookUP function.
%%%
%%% Note:
%%% Since the lists to search are so small(60 items), no attempt at optimize the
%%% searched list by using two loops and removing items from searched once a
%%% classification is make.  But this optimization can be added later should
%%% be made into a more generic catogorizing routine.
categorize(_,[],[],[]).
categorize(UUT,[Control_H|Control_T],Missing,Incorrect):-
	passwd(NameC,_PasswordC,Uid,_GidC,_GecosC,_DirC,_ShellC)=Control_H,
	(   memberchk(passwd(NameC,_,Uid,_,_,_,_),UUT)
	->  %C = Control_T,
	    M = Missing,
	    I = Incorrect
	;

	    memberchk(passwd(NameU,_PasswordU,Uid,
			     _GidU,_GecosU,_DirU,_ShellU),UUT)
	->  %C = Control_T,
	    M = Missing,
	    Incorrect=[incorrect(Uid, ws(NameU),sb(NameC))|I]
	;
	    %C = Control_T,
	    Missing = [missing(name=NameC, uid=Uid)|M],
	    I = Incorrect
	),
	categorize(UUT,Control_T, M,I).


		      
	

%%% Read input: I/O
%%% Process input
%%% Output: I/O (reports)
run :- read_passwd('/usr/ghost/etc/passwd', Control),
	read_passwd('/etc/passwd',UUT), write('Reading Done\n'),
	pw_sync(UUT,Control,Missing,Incorrect),
	report(missing,Missing),
	report(incorrect,Incorrect).
