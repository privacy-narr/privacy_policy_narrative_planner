% User A can retrieve another User B's follows if A is following B

activity_pub_object(marissa,actor;damien,actor;barth,actor).
activity(follow).

did_activity(follow, A, B) :-
  activity(follow),
  activity_pub_object(A, actor),
  activity_pub_object(B, actor).

strong_holds(start, did_activity(follow, marissa, damien)).
strong_holds(start, did_activity(follow, damien, marissa)).
strong_holds(start, did_activity(follow, damien, barth)).

% Establish that an actor cannot follow themself.
strong_notholds(start, did_activity(follow, marissa, marissa)).
strong_notholds(start, did_activity(follow, damien, damien)).
strong_notholds(start, did_activity(follow, barth, barth)).

% An actor A can view another actor B's follow list if A is following B.
possible(I, action(retrieve, did_activity(follow, A, B), C), C) :-
    id(I),
    activity_pub_object(A, actor),
    activity_pub_object(B, actor),
    activity_pub_object(C, actor),
    strong_holds(I, did_activity(follow, A, B)),
    strong_holds(I, did_activity(follow, C, A)).

% Retrieving data about an activity makes it so that the actor saw the activity was
% done.
initiates(I, Action, saw(did_activity(follow, A, B), C)) :-
  id(I),
  happens(I, Action, C),
  Action=action(retrieve, did_activity(follow, A, B), C).

intends(start, saw(did_activity(follow, damien, barth), marissa), marissa).

#const tmax=3.
#show happens/3.
#show edge/2.
#show satisfies/2.
#show intends/3.
#show split/2.

