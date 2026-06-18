:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module string.
:- import_module int.
:- import_module list.
:- import_module solutions.

% Generate all integers in [Lo, Hi] inclusive, one at a time.
:- pred between(int::in, int::in, int::out) is nondet.
between(Lo, Hi, Lo) :- Lo =< Hi.
between(Lo, Hi, X)  :- Lo < Hi, between(Lo + 1, Hi, X).

% Collect the squares of all integers in [1, N].
:- pred squares_to(int::in, list(int)::out) is det.
squares_to(_N, []).   % stub: solutions/2 + between + X*X

% Count even integers in 1..N.
:- pred count_evens(int::in, int::out) is det.
count_evens(_N, 0).   % stub: solutions/2 or aggregate/4

% Generate a Pythagorean triple (A, B, C) with 1 =< A =< B =< C =< N.
:- pred pythagorean(int::in, int::out, int::out, int::out) is nondet.
pythagorean(_N, 0, 0, 0) :- fail.   % stub

% Collect all triples for bound N.
:- pred all_triples(int::in, list({int, int, int})::out) is det.
all_triples(_N, []).   % stub: solutions/2 with pythagorean

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % between is already implemented — tests should pass immediately.
    solutions(between(1, 5), Xs),
    check("between 1..5 = [1,2,3,4,5]",
        ( Xs = [1, 2, 3, 4, 5] -> yes ; no ), !IO),
    check("between 3..3 = [3]",
        ( solutions(between(3, 3), [3]) -> yes ; no ), !IO),
    check("between 5..3 = []",
        ( solutions(between(5, 3), []) -> yes ; no ), !IO),
    % Squares.
    squares_to(5, Sqs),
    check("squares_to 5 = [1,4,9,16,25]",
        ( Sqs = [1, 4, 9, 16, 25] -> yes ; no ), !IO),
    % Even count.
    count_evens(10, Evens),
    check("count_evens 10 = 5",
        ( Evens = 5 -> yes ; no ), !IO),
    % Pythagorean triples up to 20 (known: (3,4,5), (5,12,13), (6,8,10), ...).
    all_triples(20, Triples),
    check("all_triples 20: (3,4,5) present",
        ( list.member({3, 4, 5}, Triples) -> yes ; no ), !IO),
    check("all_triples 20: (5,12,13) present",
        ( list.member({5, 12, 13}, Triples) -> yes ; no ), !IO),
    check("all_triples 20: non-empty",
        ( list.length(Triples) >= 1 -> yes ; no ), !IO).
