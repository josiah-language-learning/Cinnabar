:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module string.

:- type expr
    --->  num(int)
    ;     add(expr, expr)
    ;     neg(expr).

:- type val
    --->  int_val(int)
    ;     error_val.

:- func eval(expr) = val.
eval(num(N)) = int_val(N).
eval(neg(E)) = Result :-
    ( eval(E) = int_val(N) ->
        Result = int_val(-N)
    ;
        Result = error_val
    ).
eval(add(A, B)) = Result :-
    ( eval(A) = int_val(NA), eval(B) = int_val(NB) ->
        Result = int_val(NA + NB)
    ;
        Result = error_val
    ).

main(!IO) :-
    V = eval(add(num(3), neg(num(2)))),
    io.format("eval: %s\n", [s(string.string(V))], !IO).
