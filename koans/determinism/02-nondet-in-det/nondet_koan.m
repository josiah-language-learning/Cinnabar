:- module nondet_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.

:- pred find_factor(int::in, int::out) is nondet.
find_factor(N, F) :-
    int.nondet_int_in_range(2, N - 1, F),
    N mod F = 0.

% BUG: all_factors is declared det but calls a nondet predicate directly.
:- pred all_factors(int::in, list(int)::out) is det.
all_factors(N, Factors) :-
    % DETERMINISM ERROR: find_factor is nondet, cannot call in det context
    find_factor(N, Factors).

main(!IO) :-
    all_factors(12, Fs),
    io.write_line(Fs, !IO).
