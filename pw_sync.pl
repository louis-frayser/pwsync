%-*-prolog-*-
library_directory("library").
:- use_module(report).
:- use_module(pw_file).
:- use_module([library(lambda), library(list)]).

:- dynamic([control/1, current/1]).

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

add_user(User, Current,Currrent1,Missing,Missing1) :-
    throw(error(existence_error,not_implimented)).
fix_user(User, Current,Currrent1,Missing,Missing1) :-
    throw(error(existence_error,not_implimented)).

%%% Update global state
update(PV1,PV2):-
    PV1=..[P1,V1],retractall(P1), T1=..[P1|V1], assert(T1),
    PV2=..[P2,V2],retractall(P2), T2=..[P2|V2], assert(T2).

sync_user(User) :- get_state(_Control, Current, Missing, Incorrect),
		   ( member(User, Incorrect)
		   -> fix_user(User, Current, Current1, Incorrect, Incorrect1),
		      update(current(Current1), incorect(Incorrect1))
		   ; member(User, Missing)
		     -> add_user(User, Current,Current1,Missing,Missing1),
			update(curernert(Current1), missing(Missing1))
		   ; throw(error(existence_eror, user(User)))
		   ).
	

%%% Read input: Does I/O if not cached
%%% Analyze data
get_state(Control, Current, Missing, Incorrect) :-
    ( control(Control)
    -> current(Current)
    ; read_passwd('/usr/ghost/etc/passwd', Control),
      read_passwd('/etc/passwd',Current),
      write('Reading Done\n')
    ),
    pw_sync(Current,Control,Missing,Incorrect).


%%% Cache state as globals
set_state(Control, Current, Missing, Incorrect) :-
    assert(control(Control)),
    assert(current(Current)),
    assert(missing(Missing)),
    assert(incorrect(Incorrect)).

%%% Read input: I/O
%%% Process inpu	   
%%% Output: I/O (reports)	   
run :- get_state(_Control, _Current, Missing, Incorrect),
    report(missing,Missing),
    report(incorrect,Incorrect),
    writeln("Use sync_user/1 to update passwd"),
    writeln("Use set_state/4 to cache results").
