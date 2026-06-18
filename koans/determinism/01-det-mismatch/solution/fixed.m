:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module string.

:- pred abs_val(int::in, int::out) is det.
abs_val(N, Abs) :-
    ( N >= 0 ->
        Abs = N
    ;
        Abs = -N
    ).

main(!IO) :-
    abs_val(5, A),
    abs_val(-3, B),
    io.format("abs(5) = %d, abs(-3) = %d\n", [i(A), i(B)], !IO).
