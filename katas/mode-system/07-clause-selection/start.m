:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module string.

% CLAUSE SELECTION IN MERCURY:
%
% Mercury resolves modes at compile time. When a predicate has multiple mode
% declarations, the compiler selects the appropriate clause body at compile time
% based on the calling mode — not at runtime by pattern matching.
%
% This is different from Prolog, where clause selection is purely runtime.
% In Mercury, if you call `my_length(List, N)` with List bound (in mode (in, out)),
% the compiler emits a call to the (in, out) clause body directly.

% ---- Exercise 1: integer square root, two modes ----------------------------
%
% isqrt in (in, out) mode: given N, compute the integer square root S (where S*S =< N).
% isqrt in (out, in) mode: given S, compute N = S * S.
%
% These have genuinely different implementations.

:- pred isqrt(int, int).
:- mode isqrt(in, out) is det.
:- mode isqrt(out, in) is det.
:- pragma promise_equivalent_clauses(isqrt/2).

isqrt(N::in, S::out) :-
    % stub: S = floor(sqrt(N)) — use float.sqrt and float.truncate_to_int
    S = 0, _ = N.

isqrt(N::out, S::in) :-
    N = S * S.

% ---- Exercise 2: list_sum, two modes ---------------------------------------
%
% list_sum(List, Sum): compute the sum of a list of integers.
% Mode (in, out): standard fold.
% Mode (out, in): generate ONE list that sums to Sum (e.g., [Sum]).

:- pred list_sum(list(int), int).
:- mode list_sum(in, out) is det.
:- mode list_sum(out, in) is det.
:- pragma promise_equivalent_clauses(list_sum/2).

list_sum(List::in, Sum::out) :-
    list.foldl(pred(X::in, A::in, B::out) is det :- B = A + X, List, 0, Sum).

list_sum(List::out, Sum::in) :-
    List = [Sum].   % simplest generator: a single-element list

% ---- Exercise 3: what Mercury selects at each call site --------------------
%
% show_selection/0 calls both modes of isqrt and list_sum, demonstrating that
% the correct clause fires for each.

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % isqrt forward: sqrt(9) = 3
    isqrt(9, S),
    check("isqrt(9) = 3", ( S = 3 -> yes ; no ), !IO),
    % isqrt reverse: 4^2 = 16
    isqrt(N, 4),
    check("isqrt(_, 4) gives N = 16", ( N = 16 -> yes ; no ), !IO),
    % list_sum forward
    list_sum([1, 2, 3, 4, 5], Sum),
    check("list_sum([1..5]) = 15", ( Sum = 15 -> yes ; no ), !IO),
    % list_sum reverse: generator produces [42]
    list_sum(Gen, 42),
    check("list_sum(Gen, 42) generates a list summing to 42",
        ( list_sum(Gen, 42) -> yes ; no ), !IO),
    % Exercise: add a third mode to isqrt: (in, in) is semidet —
    % succeeds iff N is a perfect square and floor(sqrt(N)) = S.
    % What must you add to the pragma? What clause body does this mode use?
    io.write_string("(See README for the clause-ambiguity exercise.)\n", !IO).
