%-*-prolog-*-
:- module(portray, [user:portray/1]).
:- dynamic portray/1.
:- multifile portray/1.

user:portray( menu(_, title(Title), Menu_items)) :-
    writeln("MENU"),
    format("~s\n", Title),
    maplist(portray,Menu_items).


portray(menu_item(Key, Description)) :-
    format("~w~t~14|~s~n", [Key, Description]).
    

    
    
