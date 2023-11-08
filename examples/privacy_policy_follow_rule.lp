% User A can retrieve another User B's follows if A is following B

%%%%%%%%%%%%
% ACTIVITY PUB OBJECTS
%

% types of activity pub objects
activity_pub_object_type(actor; direct_post).

% lay down rules about direct posts
is_activity_pub_object(O, direct_post) :-
  is_creator(A, O),                 % there has to be some creator A, we establish what is_creator looks like in the ACTIVITIES section
  is_receiver(B, O),                % there has to be some receiver B, we establish what is_receiver looks like in the ACTIVITIES section
  is_activity_pub_object(A, actor), % A and B both need to be actors
  is_activity_pub_object(B, actor).

%%%%%%%%%%%%
% ACTIVITIES
% Establish activities and how they work
is_activity(follow, create).

% actors can follow each other
did_activity(follow, A, B) :-
  is_activity(follow),
  is_activity_pub_object(A, actor),
  is_activity_pub_object(B, actor).

% actors can create objects that are not actors
did_activity(create, A, O) :-
  is_activity(create),
  is_activity_pub_object(A, actor),
  is_activity_pub_object(O, T),
  not T = actor.

is_creator(A, O) :-
  did_activity(create, A, O).

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


%%%%%%%%
% ACTIVITY PUB OPERATIONS
initiates(I, Action, received(A, O)) :-
  id(I),
  happens(I, Action, B),
  Action=action(did, did_activity(create, B, O)),
  is_activity_pub_object(B, actor),
  is_activity_pub_object(A, actor),
  is_activity_pub_object(O, direct_post),
  is_receiver(A, O).


%%%%%%%%
% PRIVACY POLICY RULES

% An actor A can view another actor B's follow list only if A is following B.
possible(I, action(retrieve, did_activity(follow, A, B), C), C) :-
    id(I),
    is_activity_pub_object(A, actor),
    is_activity_pub_object(B, actor),
    is_activity_pub_object(C, actor),
    strong_holds(I, did_activity(follow, A, B)),
    strong_holds(I, did_activity(follow, C, A)).

% An actor A can see that another actor B DM'd a third actor C if A = C or A is an admin
% possible(I, action(retrieve, did_activity(create, A, O)))

% END PRIVACY POLICY RULES
%%%%%%%%%

% Retrieving data about an activity makes it so that the actor saw the activity was done.
initiates(I, Action, saw(did_activity(follow, A, B), C)) :-
  id(I),
  happens(I, Action, C),
  Action=action(retrieve, did_activity(follow, A, B), C).


%%%%%
% STORY GENERATION STUFF

% Create actors, objects, and activites
is_activity_pub_object(marissa,actor;damien,actor;barth,actor).
is_activity_pub_object(salt,actor;pepper,actor;jose,actor).

strong_holds(start, did_activity(follow, marissa, damien)).
strong_holds(start, did_activity(follow, damien, marissa)).
strong_holds(start, did_activity(follow, damien, barth)).

intends(start, saw(did_activity(follow, damien, barth), marissa), marissa).

#const tmax=3.
#show happens/3.
#show edge/2.

