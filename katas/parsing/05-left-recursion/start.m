:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module char.
:- import_module int.
:- import_module list.
:- import_module string.

% LEFT RECURSION PROBLEM:
%   expr --> expr, [+], term | term
% In top-down parsing, `expr --> expr, ...` calls expr immediately before
% consuming any input → infinite loop. Mercury DCGs are top-down; left
% recursion must be eliminated by rewriting with an accumulator.
%
% SOLUTION: right-recursive with an accumulator that builds left-associativity.
%   expr(N) --> term(T), expr_rest(T, N)
%   expr_rest(Acc, N) --> [+], term(T), expr_rest(Acc+T, N)
%   expr_rest(Acc, Acc) --> []        (base case: return accumulator)

% Token type for this kata.
:- type token ---> num(int) ; plus ; minus ; times ; divide.

% Exercise 1: simple left-associative addition/subtraction.
% Handles: num (+ | - num)*
% expr(N) --> term(T), expr_rest(T, N)
:- pred expr(int::out, list(token)::in, list(token)::out) is semidet.
expr(_N) --> { fail }.   % stub

:- pred expr_rest(int::in, int::out, list(token)::in, list(token)::out) is det.
expr_rest(Acc, Acc) --> [].   % base case already done — add +/- cases

:- pred term(int::out, list(token)::in, list(token)::out) is semidet.
term(N) --> [num(N)].   % just a number for now

% Exercise 2: add multiplication/division at higher precedence.
% Standard recursive-descent with two levels:
%   expr  = additive:  expr_rest handles + and -
%   term  = multiplicative: term_rest handles * and /
%   factor = atom: just num(N)
:- pred expr2(int::out, list(token)::in, list(token)::out) is semidet.
expr2(_N) --> { fail }.   % stub: term2, expr2_rest

:- pred expr2_rest(int::in, int::out, list(token)::in, list(token)::out) is det.
expr2_rest(Acc, Acc) --> [].   % stub: also handle plus/minus cases

:- pred term2(int::out, list(token)::in, list(token)::out) is semidet.
term2(_N) --> { fail }.   % stub: factor, term2_rest

:- pred term2_rest(int::in, int::out, list(token)::in, list(token)::out) is det.
term2_rest(Acc, Acc) --> [].   % stub: also handle times/divide cases

:- pred factor(int::out, list(token)::in, list(token)::out) is semidet.
factor(N) --> [num(N)].

% Convenience: tokenize a simple list like [num(3), plus, num(4)].
:- func toks(list(token)) = list(token).
toks(Ts) = Ts.

:- pred parse(pred(int, list(token), list(token))::in(pred(out, in, out) is semidet),
              list(token)::in, maybe_n::out) is det.
:- type maybe_n ---> ok(int) ; fail_n.
parse(P, Ts, R) :-
    ( call(P, N, Ts, []) -> R = ok(N) ; R = fail_n ).

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % Exercise 1: left-associative + and -.
    % 10 - 3 - 2 should be (10-3)-2 = 5, not 10-(3-2) = 9.
    parse(expr, toks([num(10), minus, num(3), minus, num(2)]), R1),
    check("expr: 10-3-2 = 5 (left-assoc)",
        ( R1 = ok(5) -> yes ; no ), !IO),
    parse(expr, toks([num(3), plus, num(4)]), R2),
    check("expr: 3+4 = 7",
        ( R2 = ok(7) -> yes ; no ), !IO),
    parse(expr, toks([num(5)]), R3),
    check("expr: 5 = 5",
        ( R3 = ok(5) -> yes ; no ), !IO),
    % Exercise 2: precedence — * binds tighter than +.
    % 3 + 4 * 2 should be 3 + (4*2) = 11, not (3+4)*2 = 14.
    parse(expr2, toks([num(3), plus, num(4), times, num(2)]), R4),
    check("expr2: 3+4*2 = 11 (precedence)",
        ( R4 = ok(11) -> yes ; no ), !IO),
    % 10 - 3 - 2 still left-associative at addition level.
    parse(expr2, toks([num(10), minus, num(3), minus, num(2)]), R5),
    check("expr2: 10-3-2 = 5 (left-assoc at + level)",
        ( R5 = ok(5) -> yes ; no ), !IO),
    parse(expr2, toks([num(6), divide, num(3), divide, num(2)]), R6),
    check("expr2: 6/3/2 = 1 (left-assoc at * level)",
        ( R6 = ok(1) -> yes ; no ), !IO).
