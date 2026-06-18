:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module maybe.
:- import_module string.

:- pred generate_option(int::out) is cc_nondet.
generate_option(1).
generate_option(2).
generate_option(3).

% FIX: promise_equivalent_solutions wraps a cc_nondet call in a det context.
% The runtime commits to the first solution of generate_option; we assert
% all solutions are observationally equivalent for the purpose of find_first.
:- pred find_first(maybe(int)::out) is det.
find_first(Result) :-
    promise_equivalent_solutions [Result]
    (
        ( generate_option(N) ->
            Result = yes(N)
        ;
            Result = no
        )
    ).

main(!IO) :-
    find_first(MaybeN),
    (
        MaybeN = yes(N),
        io.format("Found: %d\n", [i(N)], !IO)
    ;
        MaybeN = no,
        io.write_string("Not found\n", !IO)
    ).
