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

% The determinism lattice for disjunctions:
%   det ; det      → det
%   det ; semidet  → det
%   semidet ; semidet → semidet
%   det ; nondet   → multi
%   semidet ; nondet → nondet
%   multi ; anything → multi (or nondet if nondet introduced)
%
% Mercury takes the *least upper bound* of the two branches in the lattice.

% Exercise 1: det ; det → det.
% Return the absolute value: negative numbers negate, others identity.
% Both branches are det — the result is det.
:- func abs_int(int) = int.
abs_int(_N) = 0.   % stub: if N < 0 then -N else N

% Exercise 2: det ; semidet → det.
% Divide X by Y, returning a default if Y = 0.
% One branch is det (default), one is semidet (division guard) — result is det.
:- func safe_div(int, int) = int.
safe_div(_X, _Y) = 0.   % stub: if Y = 0 then 0 else X // Y

% Exercise 3: semidet ; semidet → semidet.
% Return X if X is between 1 and 10, or if X is between 100 and 200.
% Succeeds if either range matches, fails otherwise — result is semidet.
:- pred in_either_range(int::in) is semidet.
in_either_range(_X) :- fail.   % stub: X >= 1, X =< 10 ; X >= 100, X =< 200

% Exercise 4: det ; nondet → multi.
% Generate: either the fixed value 0, or any element of List.
% Fixed branch is det (one solution), list branch is nondet (zero or more).
% Together they guarantee at least one solution — multi.
:- pred zero_or_elem(list(int)::in, int::out) is multi.
zero_or_elem(_List, 0).   % stub: also add the nondet branch for List elements

% Exercise 5: semidet ; nondet → nondet.
% Succeed if X is prime (semidet), or produce all factors of X (nondet).
% Since the prime check may fail, combined result is nondet.
:- pred prime_or_factor(int::in, int::out) is nondet.
prime_or_factor(_X, _N) :- fail.   % stub — leave as stub, hard to implement simply

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % Exercise 1.
    check("abs_int -5 = 5",   ( abs_int(-5) = 5  -> yes ; no ), !IO),
    check("abs_int 3 = 3",    ( abs_int(3) = 3   -> yes ; no ), !IO),
    check("abs_int 0 = 0",    ( abs_int(0) = 0   -> yes ; no ), !IO),
    % Exercise 2.
    check("safe_div 10 2 = 5", ( safe_div(10, 2) = 5 -> yes ; no ), !IO),
    check("safe_div 10 0 = 0", ( safe_div(10, 0) = 0 -> yes ; no ), !IO),
    % Exercise 3.
    check("in_either_range 5",
        ( in_either_range(5) -> yes ; no ), !IO),
    check("in_either_range 150",
        ( in_either_range(150) -> yes ; no ), !IO),
    check("in_either_range 50 fails",
        ( \+ in_either_range(50) -> yes ; no ), !IO),
    % Exercise 4.
    solutions(zero_or_elem([3, 7]), ZOE),
    check("zero_or_elem [3,7]: 0 present",
        ( list.member(0, ZOE) -> yes ; no ), !IO),
    check("zero_or_elem [3,7]: 3 present",
        ( list.member(3, ZOE) -> yes ; no ), !IO),
    check("zero_or_elem []: at least [0]",
        ( solutions(zero_or_elem([]), ZOE2), ZOE2 = [0] -> yes ; no ), !IO),
    % Observation: determinism is tracked at compile time.
    % The declarations above encode the lattice rules — change them and
    % recompile to see the determinism checker enforce the lattice.
    io.write_string("(See README for lattice discussion)\n", !IO).
