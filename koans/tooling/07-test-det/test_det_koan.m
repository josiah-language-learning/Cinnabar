:- module test_det_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.

:- pred sum_list(list(int)::in, int::out) is det.
sum_list([], 0).
sum_list([X|Xs], Sum) :-
    sum_list(Xs, Rest),
    Sum = X + Rest.

% BUG: test predicate uses direct unification `Got = 6`.
% Unification can fail (e.g., if sum_list returns 7) — the clause is semidet.
% Mercury's test convention requires test predicates to be det: on failure,
% call error/1 rather than allowing the predicate to fail silently.
:- pred test_sum is det.
test_sum :-
    sum_list([1, 2, 3], Got),
    Got = 6.

main(!IO) :-
    test_sum,
    io.write_string("all tests passed\n", !IO).
