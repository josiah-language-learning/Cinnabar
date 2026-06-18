:- module shared_state_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module int.
:- import_module list.
:- import_module string.

:- func sum_to(int) = int.
sum_to(N) = ( N =< 0 -> 0 ; N + sum_to(N - 1) ).

% FIX: separate pure computation from IO.
% Pure goals share no unique state, so & is safe.
% IO is sequential after the parallel computation completes.
main(!IO) :-
    ( A = sum_to(100) & B = sum_to(200) ),
    io.format("task A: %d\n", [i(A)], !IO),
    io.format("task B: %d\n", [i(B)], !IO).
