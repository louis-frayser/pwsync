%*-*prolog-*-

:- module(report, [report/2]).

%%% Report on findings of pw_sync/2
report(user,Comparisons) :-
	writeln(Comparisons).

report(Type,Data):-
	memberchk(Type,[missing,incorrect]),
	length(Data,Len),
	format("~w ~w~n", [Type,Len]),
	maplist(portray, Data).

portray(missing(name=Name,uid=UID)):-
    format("Missing: user ~8w,~t~24| uid ~w~n", [Name,UID]).

portray(incorrect(UID,ws(NameUU),sb(NameCon))):-
	    format("Incorrect user for UID: ~w. ws: ~w, sb:~w~n", [UID,NameUU, NameCon]).
