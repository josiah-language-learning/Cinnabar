:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module solutions.
:- import_module string.

% KEY RULE: \+ Goal is always semidet, regardless of Goal's determinism.
% \+ succeeds if Goal fails, and fails if Goal succeeds.
% Any solutions Goal would have produced are discarded.

% Exercise 1: \+ on a det predicate — result is still semidet.
:- pred nonzero(int::in) is semidet.
nonzero(N) :- \+ N = 0.   % already done — demonstrates \+ on det

% Exercise 2: \+ as an existential check with a nondet generator.
% Succeeds iff no even number exists in [1, N].
% \+ (between ... , X mod 2 = 0) checks existence, produces no output variable.
:- pred no_even_in_range(int::in) is semidet.
no_even_in_range(N) :-
    \+ (between(1, N, X), X mod 2 = 0).

% Exercise 3: \+ as a filter (correct) — variable is GROUND before \+.
% Succeeds iff N has no small factor in [2, N-1] (prime or 1 check).
:- pred no_small_factor(int::in) is semidet.
no_small_factor(N) :-
    N > 1,
    \+ (between(2, N - 1, F), N mod F = 0).

between(Lo, Hi, Lo) :- Lo =< Hi.
between(Lo, Hi, X)  :- Lo < Hi, between(Lo + 1, Hi, X).
:- pred between(int::in, int::in, int::out) is nondet.

% Exercise 4: collecting items that do NOT satisfy a predicate.
% \+ is semidet — it cannot generate solutions, only test.
% To collect "all X from a domain where P(X) is false", use solutions + \+.
:- pred odd_integers(int::in, list(int)::out) is det.
odd_integers(_N, []).   % stub: solutions/2 + between + \+ (X mod 2 = 0)

% Exercise 5: negation as a filter over an existing list.
:- pred exclude_list(list(int)::in, list(int)::in, list(int)::out) is det.
exclude_list(_List, _Excluded, []).   % stub: list.filter with \+ list.member

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % Exercise 1.
    check("nonzero 5",       ( nonzero(5) -> yes ; no ), !IO),
    check("nonzero 0 fails", ( \+ nonzero(0) -> yes ; no ), !IO),
    % Exercise 2: \+ as existential check.
    check("no_even_in_range 1 (only 1)",
        ( no_even_in_range(1) -> yes ; no ), !IO),
    check("no_even_in_range 2 fails (2 is even)",
        ( \+ no_even_in_range(2) -> yes ; no ), !IO),
    % Exercise 3.
    check("no_small_factor 7",
        ( no_small_factor(7) -> yes ; no ), !IO),
    check("no_small_factor 9 fails",
        ( \+ no_small_factor(9) -> yes ; no ), !IO),
    % Exercise 4.
    odd_integers(10, Odds),
    check("odd_integers 10 = [1,3,5,7,9]",
        ( Odds = [1, 3, 5, 7, 9] -> yes ; no ), !IO),
    % Exercise 5.
    exclude_list([1, 2, 3, 4, 5], [2, 4], Excl),
    check("exclude_list [1..5] excl [2,4] = [1,3,5]",
        ( Excl = [1, 3, 5] -> yes ; no ), !IO),
    % Pitfall note (compile-time):
    % Uncomment to see the mode error — X is free when it reaches \+:
    % solutions((pred(X::out) is semidet :- \+ between(1, 5, X)), _)
    io.write_string("(See README for \\+ pitfall discussion)\n", !IO).
