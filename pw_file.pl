%%%% IO fo for /etc/passwd and
%%%% Operations on pwent
:- module(pw_file, [read_passwd/2,is_colon/1,is_nl/1]).

	

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
