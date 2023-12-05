% User A can retrieve another User B's follows if A is following B
mastermind.

%%%%%%%%%%%%
% ACTIVITY PUB OBJECTS
%

% types of activity pub objects
activity_pub_object_type(actor).

%%%%%%%%%%%%
% ACTIVITIES
% Establish activities and how they work
is_activity(follow).

% actors can follow each other
did_activity(follow, A, B) :-
  is_activity(follow),
  is_activity_pub_object(A, actor),
  is_activity_pub_object(B, actor).

% END ACTIVITIES
%%%%%%%%%%%%


%%%%%%%
% ACTORS
% establish actors

% establish actor roles and how they work
actor_role(admin).

has_actor_role(A, Role) :-
  is_activity_pub_object(A, actor),
  actor_role(Role).

% actor(A) :-
%   is_activity_pub_object(A, actor).

%%%%%%%%
% ACTIVITY PUB OPERATIONS

%%%%%%%%
% PRIVACY POLICY RULES
is_policy_writer(policy_writer).

% An actor A can view another actor B's follow list only if A is following B.
possible(I, action(retrieve, did_activity(follow, A, B), C), C) :-
  id(I),
  strong_holds(I, is_policy_applied(follow_list_retrieve_followers_only)),
  is_activity_pub_object(A, actor),
  is_activity_pub_object(B, actor),
  is_activity_pub_object(C, actor),
  strong_holds(I, did_activity(follow, A, B)),
  strong_holds(I, did_activity(follow, C, A)).

possible(I, action(retrieve, did_activity(follow, A, B), C), C) :-
  id(I),
  strong_holds(I, is_policy_applied(follow_list_retrieve_public)),
  is_activity_pub_object(A, actor),
  is_activity_pub_object(B, actor),
  is_activity_pub_object(C, actor).

possible(I, action(apply_policy, PID, W), W) :-
  id(I),
  policy_id(PID),
  is_policy_writer(W).

policy_id(follow_list_retrieve_public; follow_list_retrieve_followers_only).

% An actor A can see that another actor B DM'd a third actor C if A = C or A is an admin
% possible(I, action(retrieve, did_activity(create, A, O)))

% END PRIVACY POLICY RULES
%%%%%%%%%

% Retrieving data about an activity makes it so that the actor saw the activity was done.
initiates(I, Action, saw(did_activity(Activity, A, B), C)) :-
  happens(I, Action, C),
  is_activity(Activity),
  Action=action(retrieve, did_activity(Activity, A, B), C).

initiates(I, Action, is_policy_applied(PID)) :-
  happens(I, Action, A),
  Action=action(apply_policy, PID, W).


%%%%%
% STORY GENERATION STUFF

% Create actors, objects, and activites
is_activity_pub_object(marissa,actor;damien,actor;barth,actor;alyssa,actor).
strong_holds(start, did_activity(follow, marissa, damien)).
strong_holds(start, did_activity(follow, damien, marissa)).
strong_holds(start, did_activity(follow, damien, barth)).
strong_notholds(start, did_activity(follow, alyssa, damien)).

:- not strong_holds(end, saw(did_activity(follow, damien, barth), marissa)).
:- not strong_holds(end, saw(did_activity(follow, damien, barth), alyssa)).


:- not strong_holds(end, is_policy_applied(follow_list_retrieve_public)).
:- not strong_holds(end, is_policy_applied(follow_list_retrieve_followers_only)).
% :- not actor(marissa).
% intends(start, saw(did_activity(follow, damien, barth), alyssa), alyssa).

% :- not happens(_, action(retrieve, _), _).

#const tmax=10.
#show happens/3.
#show edge/2.

