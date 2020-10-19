%-*-prolog-*-
/*** This module is incomplete
**** for now load pw_sync.pl and use run/0 for testing
*/
%%:- use_module(user_info).
/*:- dynamic portray/1.
:- multifile portray/1.
*/
:- set_prolog_flag(verbose,silent).
:- use_module(portray).


run_menu(MenuID) :-
    Menu=menu(MenuID, _,_),
    Menu,
    portray(Menu).


%% menu(ID, title(String), Itemlist)
menu(main,
     title("Password Compare"),
     [
	 menu_item(user,  "User passwd entry compare between two hosts")
	 ,
	 menu_item(passwd,"Compare Password Files between two hosts")
	 ,
	 menu_item(pwlint,"Check password consistencies")
     ]).

main :- run_menu(main).

:- main.
