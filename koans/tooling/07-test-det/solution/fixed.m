:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module require.
:- import_module string.

:- pred sum_list(list(int)::in, int::out) is det.
sum_list([], 0).
sum_list([X|Xs], Sum) :-
    sum_list(Xs, Rest),
    Sum = X + Rest.

% FIX: test predicate uses error/1 on failure instead of failing silently.
% The predicate remains det: it either succeeds silently or throws an error.
% Direct unification `Got = 6` is semidet — it must be wrapped in an
% if-then-else with error/1 in the else branch.
:- pred test_sum is det.
test_sum :-
    sum_list([1, 2, 3], Got),
    ( Got = 6 ->
        true
    ;
        error("test_sum failed: expected 6, got " ++ string.int_to_string(Got))
    ).

main(!IO) :-
    test_sum,
    io.write_string("all tests passed\n", !IO).
