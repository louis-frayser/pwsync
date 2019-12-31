library_directory("library").

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

	

read_passwd(Spec,Pws) :-
	read_file_to_codes(Spec,Cs,[]),
	maplist(lambda:chr,Cs,As),
	decode_pw(As,Pws).

%%% Outputs list ...
%%% [pw(mythtv, x, 496, 493, MythTV backend client, /var/lib/mythtv, /sbin/nologin)..
decode_pw([],[]).
decode_pw(['\n'],[]).
decode_pw(Atoms,[passwd(Name,Passwd,Uid,Gid,Gecos,Dir,Shell)|Pws]) :-

        break(  Name1-[:|Rest1],is_colon,Atoms), name(Name,Name1),
        break(Passwd1-[:|Rest2],is_colon,Rest1), name(Passwd,Passwd1),
        break(   Uid1-[:|Rest3],is_colon,Rest2), name(Uid,Uid1),
        break(   Gid1-[:|Rest4],is_colon,Rest3), name(Gid,Gid1),
        break( Gecos1-[:|Rest5],is_colon,Rest4), name(Gecos,Gecos1),
        break(   Dir1-[:|Rest6],is_colon,Rest5), name(Dir,Dir1),
        break( Shell1-[_|Rest ],is_nl   ,Rest6), name(Shell,Shell1),
	decode_pw(Rest, Pws).


is_colon(:).
is_nl('\n').
