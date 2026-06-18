:- module parallel_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.

:- func range_sum(int, int) = int.
range_sum(Lo, Hi) =
    ( Lo > Hi -> 0 ; Lo + range_sum(Lo + 1, Hi) ).

% BUG: find_something is semidet but will be used in a parallel conjunction.
:- pred find_something(int::out) is semidet.
find_something(42).

main(!IO) :-
    % DETERMINISM ERROR: find_something is semidet, cannot use in &
    S = range_sum(1, 100000)
    &
    find_something(X),
    io.format("Sum: %d, Found: %d\n", [i(S), i(X)], !IO).
