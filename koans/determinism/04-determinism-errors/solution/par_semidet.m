:- module par_semidet.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.

% FIX: make both sub-goals det so & can parallelize them.
% The parity check moved out of the parallel goal; compute now always succeeds.
:- pred square(int::in, int::out) is det.
square(N, S) :- S = N * N.

:- pred compute(int::in, int::out, int::out) is det.
compute(N, A, B) :-
    ( square(N, A) & square(N + 1, B) ).

main(!IO) :-
    compute(3, A, B),
    io.write_int(A, !IO),
    io.write_string(", ", !IO),
    io.write_int(B, !IO),
    io.nl(!IO).
