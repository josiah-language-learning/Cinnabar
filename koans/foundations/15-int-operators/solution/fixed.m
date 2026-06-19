:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module string.

:- pred show_if_different(int::in, int::in, io::di, io::uo) is det.
show_if_different(A, B, !IO) :-
    ( A \= B ->
        io.format("%d and %d differ\n", [i(A), i(B)], !IO)
    ;
        io.write_string("equal\n", !IO)
    ).

main(!IO) :-
    show_if_different(3, 4, !IO),
    show_if_different(5, 5, !IO).
