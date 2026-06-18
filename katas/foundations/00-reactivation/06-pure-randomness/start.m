:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module random.
:- import_module random.system_rng.
:- import_module string.

% roll_d6: produce a random int in 1..6 using the system RNG.
% Supply RNG state as a pair (Supply, !IO) if using random.supply.
% For now: use random.system to get a supply, then random.random to draw a value.
:- pred roll_d6(int::out, io::di, io::uo) is det.
roll_d6(N, !IO) :-
    N = 1.   % stub: use random.system.init and random.random

% roll_n: roll `Count` dice, accumulate into a list.
:- pred roll_n(int::in, list(int)::out, io::di, io::uo) is det.
roll_n(Count, Result, !IO) :-
    ( Count =< 0 ->
        Result = []
    ;
        roll_d6(D, !IO),
        roll_n(Count - 1, Rest, !IO),
        Result = [D | Rest]
    ).

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    roll_d6(D, !IO),
    check("roll_d6 in range 1-6", ( D >= 1, D =< 6 -> yes ; no ), !IO),
    roll_n(10, Rolls, !IO),
    check("roll_n gives 10 results",
          ( list.length(Rolls) = 10 -> yes ; no ), !IO),
    io.format("Rolls: %s\n", [s(string.string(Rolls))], !IO).
