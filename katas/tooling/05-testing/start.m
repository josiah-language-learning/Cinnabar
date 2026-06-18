:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module exception.
:- import_module int.
:- import_module list.
:- import_module solutions.
:- import_module string.

% ============================================================
% Testing helpers — the kata is about building and using these
% ============================================================

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

:- pred check_equal(string::in, T::in, T::in, io::di, io::uo) is det.
check_equal(Name, Expected, Actual, !IO) :-
    ( Expected = Actual ->
        io.format("PASS: %s\n", [s(Name)], !IO)
    ;
        io.format("FAIL: %s\n  expected: %s\n  actual:   %s\n",
                  [s(Name),
                   s(string.string(Expected)),
                   s(string.string(Actual))], !IO)
    ).

:- pred check_solutions(string::in, list(T)::in,
                        pred(T)::in(pred(out) is nondet),
                        io::di, io::uo) is det.
check_solutions(Name, Expected, Goal, !IO) :-
    solutions(Goal, Actual),
    list.sort(Expected, ExpSorted),
    list.sort(Actual,   ActSorted),
    check_equal(Name, ExpSorted, ActSorted, !IO).

% Exception testing:
%   exception.try(Goal, Result) is cc_multi — not directly usable from det.
%   Wrap with promise_equivalent_solutions to downgrade to det.
%   The GOAL must be (pred(out) is det), not erroneous — so write a predicate
%   that throws on a specific input (det: either succeeds or throws).
:- pred check_exception(string::in, pred(int)::in(pred(out) is det),
                        io::di, io::uo) is det.
check_exception(Name, Goal, !IO) :-
    promise_equivalent_solutions [TryRes] exception.try(Goal, TryRes),
    check(Name, ( TryRes = exception(_) -> yes ; no ), !IO).

% ============================================================
% Subject under test
% ============================================================

:- func my_max(int, int) = int.
my_max(A, B) = ( A >= B -> A ; B ).

:- pred between(int::in, int::in, int::out) is nondet.
between(Lo, Hi, X) :-
    Lo =< Hi,
    ( X = Lo ; between(Lo + 1, Hi, X) ).

% safe_div: det — throws on zero denominator, otherwise divides.
% A det predicate that conditionally throws can be passed to exception.try.
:- pred safe_div(int::in, int::in, int::out) is det.
safe_div(A, B, C) :-
    ( B = 0 ->
        throw(software_error("division by zero"))
    ;
        C = A / B
    ).

% ============================================================
% Tests
% ============================================================

main(!IO) :-
    check("check helper works", yes, !IO),
    check_equal("my_max(3,5)", 5, my_max(3, 5), !IO),
    check_equal("my_max(7,2)", 7, my_max(7, 2), !IO),
    check_solutions("between(1,3)", [1, 2, 3], between(1, 3), !IO),
    check_exception("safe_div(10,0) throws",
                    (pred(R::out) is det :- safe_div(10, 0, R)), !IO),
    safe_div(10, 2, Q),
    check_equal("safe_div(10,2)", 5, Q, !IO).
