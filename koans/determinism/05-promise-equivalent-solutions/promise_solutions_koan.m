:- module promise_solutions_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module string.

% Find the maximum element of a list. Any maximum equals any other maximum,
% so all solutions are equivalent — promise_equivalent_solutions should work.
%
% BUG: declared det but inferred semidet.
% promise_equivalent_solutions removes the multi-solution problem but NOT the
% can-fail problem. The inner goal can fail (empty list → no member), so the
% wrapped goal is cc_nondet, not cc_multi.
% promise_equivalent_solutions on cc_nondet gives semidet, not det.
:- pred list_max(list(int)::in, int::out) is det.
list_max(Xs, Max) :-
    promise_equivalent_solutions [Max] (
        list.member(Max, Xs),
        \+ (list.member(Y, Xs), Y > Max)
    ).

main(!IO) :-
    list_max([3, 1, 4, 1, 5, 9, 2, 6], Max),
    io.format("Max: %d\n", [i(Max)], !IO).
