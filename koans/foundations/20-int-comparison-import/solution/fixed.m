:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module string.

:- pred classify(int::in, string::out) is det.
classify(N, Class) :-
    ( N > 0 ->
        Class = "positive"
    ; N < 0 ->
        Class = "negative"
    ;
        Class = "zero"
    ).

main(!IO) :-
    classify(5, C1),
    classify(-3, C2),
    classify(0, C3),
    io.format("%s %s %s\n", [s(C1), s(C2), s(C3)], !IO).
