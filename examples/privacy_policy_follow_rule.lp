% User A can retrieve another User B's follows if A is following B

%%%%%%%%%%%%
% ACTIVITY PUB OBJECTS
%
mastermind.
% types of activity pub objects
activity_pub_object_type(actor).

is_activity_pub_object(A, actor)
  :- actor(A).

%%%%%%%%%%%%
% ACTIVITIES
% Establish activities and how they work
is_activity(follow, create).

% actors cannot follow themself
% :- did_activity(follow, A, B), A = B.
% non-actors cannot follow or be followed
% :- did_activity(follow, A, B), not actor(A); not actor(B).

% END ACTIVITIES
%%%%%%%%%%%%


%%%%%%%
% ACTORS
% establish actors

%%%%%%%%
% PRIVACY POLICY RULES
policy_id(follow_retrieve_followersOnly).
policy_id(follow_retrieve_public).

% Only followers can view another actor's follow list.
possible(I, action(retrieve(follow, Follower, Followed, Observer)), al(Observer)) :-
    id(I),
    is_following(Follower, Followed),
    is_following(Observer, Follower),
    policy_applied(follow_retrieve_followersOnly).

% An actor's follow list is public.
possible(I, action(retrieve(follow, Follower, Followed, Observer)), al(Observer)) :-
    id(I),
    actor(Observer),
    is_following(Follower, Followed),
    policy_applied(follow_retrieve_public).

% END PRIVACY POLICY RULES
%%%%%%%%%

% Retrieving data about an activity makes it so that the actor saw the activity was done.
initiates(I, Action, saw(follow, Follower, Followed, Observer)) :-
  happens(I, Action, al(Observer)),
  Action=action(retrieve(follow, Follower, Followed, Observer)).

%%%%%
% STORY GENERATION STUFF

% Create actors, objects, and activites
actor(marissa).
actor(barth).
actor(damien).
actor(alyssa).
actor(tri).

is_following(marissa, damien).
is_following(damien, marissa).
is_following(damien, barth).
is_following(tri, damien).
:- is_following(alyssa, _).


#const tmax=3.
#show happens/3.
#show edge/2.
#show policy_applied/1.
% #show did_activity/3.
#show strong_holds/2.
#show intendsM/0.
#show intendsA/0.
#show split/2.
