:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module maybe.
:- import_module string.

:- func range_sum(int, int) = int.
range_sum(Lo, Hi) =
    ( Lo > Hi -> 0 ; Lo + range_sum(Lo + 1, Hi) ).

% FIX: det function returning maybe(int)
:- func find_something = maybe(int).
find_something = yes(42).

main(!IO) :-
    S = range_sum(1, 100000)
    &
    MaybeX = find_something,
    (
        MaybeX = yes(X),
        io.format("Sum: %d, Found: %d\n", [i(S), i(X)], !IO)
    ;
        MaybeX = no,
        io.format("Sum: %d, Not found\n", [i(S)], !IO)
    ).
