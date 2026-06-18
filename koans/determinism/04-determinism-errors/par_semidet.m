:- module par_semidet.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.

% BUG: parallel conjunction (&) requires both sub-goals to be det.
% odd_square and even_square are semidet — they can fail when the parity
% condition is not met. Mercury cannot parallelize goals that may fail.
:- pred odd_square(int::in, int::out) is semidet.
odd_square(N, S) :-
    N mod 2 = 1,
    S = N * N.

:- pred even_square(int::in, int::out) is semidet.
even_square(N, S) :-
    N mod 2 = 0,
    S = N * N.

:- pred compute(int::in, int::out, int::out) is det.
compute(N, A, B) :-
    ( odd_square(N, A) & even_square(N + 1, B) ).

main(!IO) :-
    compute(3, A, B),
    io.write_int(A, !IO),
    io.write_string(", ", !IO),
    io.write_int(B, !IO),
    io.nl(!IO).
