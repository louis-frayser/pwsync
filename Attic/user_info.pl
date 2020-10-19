%-*-prolog-*-
:- module(user_info [user_info/1])
use_module(report).
user_module(database).

/*
Queries and reports based on UserID
*/

/*
Compare user on localhost and on old host
Show UID difference
Show Group difference
Compare gecos, homedir and shell
Compare any user aliases

Compare group memberships
Compare any group aliases
Compare any other users in the referenced groups.

Testcase user_info(postgres).
*/
/*
Procedure:
Initialize the database
Get password entries from both hosts
Compare passwords and groups for the specified user. This also needs to
flag discrepencies between group-id to groupname mappings.
*/

user_info(User) :-
	reload_db,		% Reinitialize data from passwd files.
	user_pwent_on_host(User,L_Pwent,localhost),
	user_pwent_on_host(User,H_Pwent,havana),
	%% Needs to also verify groups to GID mappings.
	compare_pwents(havana-H_Pwent,localhost-L_Pwent,Comp),
	report(user,Comp).



	       
	
	
	
	
	
	
	
