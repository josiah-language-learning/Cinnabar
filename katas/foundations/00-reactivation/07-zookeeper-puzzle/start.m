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

% A simplified Zebra/Einstein puzzle with 3 positions.
%
% Clues:
%   1. The keeper in position 1 feeds lions.
%   2. The snake keeper is immediately right of the parrot keeper.
%   3. The eagle keeper is in position 3.

:- type animal ---> lion ; parrot ; snake ; eagle.

% solution record to avoid pair/arithmetic ambiguity
:- type zoo_solution ---> zoo_sol(int, int, int, int).

% consistent: the assignment satisfies all clues simultaneously.
:- pred consistent(int::in, int::in, int::in, int::in) is semidet.
consistent(LionPos, ParrotPos, SnakePos, EaglePos) :-
    LionPos = 1,
    SnakePos = ParrotPos + 1,
    EaglePos = 3,
    LionPos \= ParrotPos, LionPos \= SnakePos, LionPos \= EaglePos,
    ParrotPos \= SnakePos, ParrotPos \= EaglePos,
    SnakePos \= EaglePos,
    LionPos >= 1,   LionPos   =< 3,
    ParrotPos >= 1, ParrotPos =< 3,
    SnakePos >= 1,  SnakePos  =< 3,
    EaglePos >= 1,  EaglePos  =< 3.

:- pred solve(int::out, int::out, int::out, int::out) is nondet.
solve(LionPos, ParrotPos, SnakePos, EaglePos) :-
    member(LionPos,   [1,2,3]),
    member(ParrotPos, [1,2,3]),
    member(SnakePos,  [1,2,3]),
    member(EaglePos,  [1,2,3]),
    consistent(LionPos, ParrotPos, SnakePos, EaglePos).

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    solutions(
        (pred(zoo_sol(L,P,Sn,E)::out) is nondet :- solve(L, P, Sn, E)),
        Sols),
    ( Sols = [zoo_sol(LionP, ParrotP, SnakeP, EagleP)] ->
        io.format("Lion=%d Parrot=%d Snake=%d Eagle=%d\n",
                  [i(LionP), i(ParrotP), i(SnakeP), i(EagleP)], !IO),
        check("unique solution",  yes, !IO),
        check("snake in pos 2",   ( SnakeP  = 2 -> yes ; no ), !IO),
        check("eagle in pos 3",   ( EagleP  = 3 -> yes ; no ), !IO),
        check("lion in pos 1",    ( LionP   = 1 -> yes ; no ), !IO),
        check("parrot in pos 2",  ( ParrotP = 2 -> yes ; no ), !IO)
    ;
        io.write_string("no unique solution found\n", !IO),
        check("unique solution", no, !IO)
    ).
