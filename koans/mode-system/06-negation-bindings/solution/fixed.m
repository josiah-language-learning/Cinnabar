:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module list.
:- import_module string.

:- type priority ---> low ; medium ; high.
:- type task ---> task(name :: string, priority :: priority).

% Fix: use list.find_first_match — semidet, commits to the first match.
% The predicate argument tests each element; find_first_match binds T to
% the first element that passes the test.
:- pred find_important(list(task)::in, task::out) is semidet.
find_important(Tasks, T) :-
    list.find_first_match(
        (pred(X::in) is semidet :- X ^ priority \= low),
        Tasks, T).

main(!IO) :-
    Tasks = [task("plan", low), task("code", high), task("review", medium)],
    ( find_important(Tasks, Found) ->
        io.format("Important: %s\n", [s(Found ^ name)], !IO)
    ;
        io.write_string("None found\n", !IO)
    ).
