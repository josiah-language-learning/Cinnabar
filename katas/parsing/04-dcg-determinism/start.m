:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module char.
:- import_module int.
:- import_module list.
:- import_module solutions.
:- import_module string.

% PROBLEM: DCG rules with an empty alternative ([] ;) are multi or nondet —
% because Mercury cannot prove the empty and non-empty cases are mutually
% exclusive. Both clauses can fire for the same input.
%
% SOLUTION: use if-then-else inside a single clause to commit to one path.

% Exercise 1: optional sign — multi because both clauses can match.
% When input starts with '-': clause 1 (empty) succeeds AND clause 2 (consume)
% succeeds. Two solutions. When input is empty: only clause 1 matches, multi.
:- pred opt_sign_multi(int::out, list(char)::in, list(char)::out) is multi.
opt_sign_multi(1)  --> [].      % always matches (positive/default)
opt_sign_multi(-1) --> ['-'].   % also matches when '-' is present

% Exercise 2: rewrite opt_sign as semidet using if-then-else.
% Look at the first character; if '-', consume and return -1; otherwise +1.
% Single clause, immediate commitment — semidet (always succeeds here = det).
:- pred opt_sign_det(int::out, list(char)::in, list(char)::out) is det.
opt_sign_det(1) --> [].   % stub: if ['-'] then -1 else (no consume) 1

% Exercise 3: semidet sign — requires a sign character, fails if absent.
% Multi-clause version: Mercury proves these mutually exclusive → semidet.
:- pred sign_semidet(int::out, list(char)::in, list(char)::out) is semidet.
sign_semidet(1)  --> ['+'].
sign_semidet(-1) --> ['-'].

% Exercise 4: a det digit parser — always consumes one char, returns 0..9 or -1.
:- pred digit_val(int::out, list(char)::in, list(char)::out) is semidet.
digit_val(_N) --> { fail }.   % stub: [C], { char.digit_to_int(C, N) }

% Exercise 5: parse a sequence of digits into an integer (one or more).
:- pred digits(int::out, list(char)::in, list(char)::out) is semidet.
digits(_N) --> { fail }.   % stub: digit_val first, then digit_val* accumulating

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

:- pred try_semidet(pred(T, list(char), list(char)), list(char), maybe_r(T)).
:- mode try_semidet(pred(out, in, out) is semidet, in, out) is det.
:- type maybe_r(T) ---> ok(T) ; no_parse.
try_semidet(P, Input, R) :-
    ( call(P, V, Input, []) -> R = ok(V) ; R = no_parse ).

:- pred try_det(pred(T, list(char), list(char)), list(char), T).
:- mode try_det(pred(out, in, out) is det, in, out) is det.
try_det(P, Input, V) :- call(P, V, Input, _Rest).

main(!IO) :-
    % Exercise 1: opt_sign_multi produces 2 solutions on '-' input.
    solutions(
        (pred(V::out) is nondet :- opt_sign_multi(V, ['-'], _)),
        Multi),
    check("opt_sign_multi '-': 2 solutions",
        ( list.length(Multi, 2) -> yes ; no ), !IO),
    solutions(
        (pred(V::out) is nondet :- opt_sign_multi(V, [], [])),
        Multi2),
    check("opt_sign_multi []: 1 solution (only empty clause)",
        ( Multi2 = [1] -> yes ; no ), !IO),
    % Exercise 2: opt_sign_det commits — exactly one solution.
    try_det(opt_sign_det, ['-'], DS),
    check("opt_sign_det '-' = -1", ( DS = -1 -> yes ; no ), !IO),
    try_det(opt_sign_det, ['+'], PS),
    check("opt_sign_det '+' = 1 (no sign consumed)",
        ( PS = 1 -> yes ; no ), !IO),
    try_det(opt_sign_det, [], ES),
    check("opt_sign_det [] = 1", ( ES = 1 -> yes ; no ), !IO),
    % Exercise 3: sign_semidet (Mercury proves exclusion from patterns).
    try_semidet(sign_semidet, ['+'], SR1),
    check("sign_semidet '+' = 1", ( SR1 = ok(1) -> yes ; no ), !IO),
    try_semidet(sign_semidet, ['x'], SR2),
    check("sign_semidet 'x' fails", ( SR2 = no_parse -> yes ; no ), !IO),
    % Exercise 4: digit_val.
    try_semidet(digit_val, ['7'], DR),
    check("digit_val '7' = 7", ( DR = ok(7) -> yes ; no ), !IO),
    try_semidet(digit_val, ['a'], DA),
    check("digit_val 'a' fails", ( DA = no_parse -> yes ; no ), !IO),
    % Exercise 5: digits.
    try_semidet(digits, ['4', '2'], NR),
    check("digits \"42\" = 42", ( NR = ok(42) -> yes ; no ), !IO),
    try_semidet(digits, ['1', '2', '3'], NR2),
    check("digits \"123\" = 123", ( NR2 = ok(123) -> yes ; no ), !IO).
