:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module solutions.

:- pred find_factor(int::in, int::out) is nondet.
find_factor(N, F) :-
    int.nondet_int_in_range(2, N - 1, F),
    N mod F = 0.

% FIX: use solutions/2 to collect nondet results into a det list
:- pred all_factors(int::in, list(int)::out) is det.
all_factors(N, Factors) :-
    solutions(find_factor(N), Factors).

main(!IO) :-
    all_factors(12, Fs),
    io.write_line(Fs, !IO).
