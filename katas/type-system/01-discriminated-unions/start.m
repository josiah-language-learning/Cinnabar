:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module list.
:- import_module string.
:- import_module int.
:- import_module maybe.

% Phase 1: basic expression type (no division — eval is det).
:- type expr
    --->    num(int)
    ;       add(expr, expr)
    ;       mul(expr, expr)
    ;       neg(expr)
    ;       sub(expr, expr)
    ;       div(expr, expr).   % added in Phase 2

% Phase 1: det evaluator — every expr has exactly one int value.
:- func eval(expr) = int.
eval(_) = 0.   % stub: pattern-match all constructors

% Phase 2: safe_eval wraps eval in maybe — fails on division by zero.
:- func safe_eval(expr) = maybe(int).
safe_eval(_) = maybe.no.   % stub

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % Phase 1 tests.
    check("eval num(5) = 5",
        ( eval(num(5)) = 5 -> yes ; no ), !IO),
    check("eval add(num(3), num(4)) = 7",
        ( eval(add(num(3), num(4))) = 7 -> yes ; no ), !IO),
    check("eval mul(num(2), num(6)) = 12",
        ( eval(mul(num(2), num(6))) = 12 -> yes ; no ), !IO),
    check("eval neg(num(3)) = -3",
        ( eval(neg(num(3))) = -3 -> yes ; no ), !IO),
    check("eval sub(num(10), num(4)) = 6",
        ( eval(sub(num(10), num(4))) = 6 -> yes ; no ), !IO),
    check("eval (3+4)*neg(2) = -14",
        ( eval(mul(add(num(3), num(4)), neg(num(2)))) = -14 -> yes ; no ), !IO),
    % Phase 2 tests.
    check("safe_eval 10/2 = yes(5)",
        ( safe_eval(div(num(10), num(2))) = yes(5) -> yes ; no ), !IO),
    check("safe_eval 10/0 = no",
        ( safe_eval(div(num(10), num(0))) = no -> yes ; no ), !IO),
    check("safe_eval num(7) = yes(7)",
        ( safe_eval(num(7)) = yes(7) -> yes ; no ), !IO).
