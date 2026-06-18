:- module nondet_direct.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module solutions.
:- import_module string.

:- pred find_factor(int::in, int::out) is nondet.
find_factor(N, F) :-
    int.nondet_int_in_range(2, N - 1, F),
    N mod F = 0.

% FIX: use solutions/2 to collect all nondet results into a list.
% Then work with the list in the det context.
:- pred first_factor(int::in, int::out) is semidet.
first_factor(N, F) :-
    solutions.solutions(find_factor(N), Fs),
    Fs = [F | _].

main(!IO) :-
    ( first_factor(12, F) ->
        io.write_string("first factor: ", !IO),
        io.write_int(F, !IO),
        io.nl(!IO)
    ;
        io.write_string("no factors found\n", !IO)
    ).
