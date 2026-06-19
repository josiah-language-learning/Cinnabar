:- module negation_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module list.
:- import_module string.

:- type priority ---> low ; medium ; high.
:- type task ---> task(name :: string, priority :: priority).

% Find any task that is not low priority.
%
% BUG: T is free before \+, and bindings inside \+ don't escape.
% list.member/2 binds T inside the negation, but after \+, T is still free.
% Using T as an `out' argument requires it to be ground — mode error.
:- pred find_important(list(task)::in, task::out) is semidet.
find_important(Tasks, T) :-
    \+ (list.member(T, Tasks), T ^ priority = low).

main(!IO) :-
    Tasks = [task("plan", low), task("code", high), task("review", medium)],
    ( find_important(Tasks, Found) ->
        io.format("Important: %s\n", [s(Found ^ name)], !IO)
    ;
        io.write_string("None found\n", !IO)
    ).
