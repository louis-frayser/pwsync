:- module(report,report/2).

%%% Report on findings of pw_sync/2
report(user,Comparisons) :-
	writeln(Comparisons).

report(Type,Data):-
	memberchk(Type,[missing,incorrect]),
	length(Data,Len),
	format('~w ~w\n',[Len,Type]),
	writeln(Data).
