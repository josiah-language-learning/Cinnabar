:- module int_cmp_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module list.
:- import_module string.
% Missing: import_module int.
% Without it, >, <, >=, =< are all undefined.

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
