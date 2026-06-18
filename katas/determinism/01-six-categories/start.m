:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module string.
:- import_module exception.
:- import_module int.
:- import_module list.
:- import_module solutions.

% det — total arithmetic evaluator (simple version without div).
:- type expr ---> num(int) ; add(expr, expr) ; mul(expr, expr) ; neg(expr).

:- func eval(expr) = int.
eval(_) = 0.   % stub: handle all constructors

% semidet — fails on empty list; succeeds with head otherwise.
:- pred safe_head(list(T)::in, T::out) is semidet.
safe_head([], _) :- fail.   % stub: match [H|_]

% multi — coin combinations summing to N pence using [1,2,5,10].
% At least one solution always exists (all 1p), so this is multi not nondet.
:- pred coin_combo(int::in, list(int)::out) is multi.
coin_combo(_, [1]).   % stub: generate actual combinations

% nondet — integer factors of N in range 2..N-1.
:- pred factor(int::in, int::out) is nondet.
factor(_, _) :- fail.   % stub

% erroneous — always throws, never returns.
:- pred abort(string::in) is erroneous.
abort(Msg) :- throw(software_error(Msg)).

% failure — always fails.
:- pred always_fails is failure.
always_fails :- fail.

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % 1. det.
    check("eval num(5) = 5",
        ( eval(num(5)) = 5 -> yes ; no ), !IO),
    check("eval add(num(3),num(4)) = 7",
        ( eval(add(num(3), num(4))) = 7 -> yes ; no ), !IO),
    % 2. semidet.
    check("safe_head [1,2,3] = 1",
        ( safe_head([1, 2, 3], H), H = 1 -> yes ; no ), !IO),
    check("safe_head [] fails",
        ( \+ safe_head([], _) -> yes ; no ), !IO),
    % 3. multi — collect all coin combinations for 5p.
    solutions(coin_combo(5), Combos),
    check("coin_combo 5: at least one solution",
        ( list.length(Combos) >= 1 -> yes ; no ), !IO),
    check("coin_combo 5: all-1p solution present",
        ( list.member([1,1,1,1,1], Combos) -> yes ; no ), !IO),
    % 4. nondet — factors of 12.
    solutions(factor(12), Factors),
    check("factors of 12: includes 2",
        ( list.member(2, Factors) -> yes ; no ), !IO),
    check("factors of 12: includes 3, 4, 6",
        ( list.member(3, Factors), list.member(4, Factors),
          list.member(6, Factors) -> yes ; no ), !IO),
    check("factors of 1 (prime has none): empty",
        ( solutions(factor(1), F1), F1 = [] -> yes ; no ), !IO),
    % 5. erroneous — caught via exception.try.
    promise_equivalent_solutions [AbortTry] exception.try(
        (pred(R::out) is det :- abort("test"), R = 0),
        AbortTry),
    check("abort throws",
        ( AbortTry = exception(_) -> yes ; no ), !IO),
    % 6. failure — used in a disjunction.
    ( always_fails
    ; io.write_string("always_fails dead end caught\n", !IO)
    ),
    check("always_fails: the else branch ran",
        ( true -> yes ; no ), !IO).
