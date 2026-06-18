:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module string.

:- pred classify(int::in, string::out) is det.
classify(N, Category) :-
    Threshold = 100,   % FIX: bound before use in condition
    ( N > Threshold ->
        Category = "high"
    ;
        Category = "low"
    ).

main(!IO) :-
    classify(150, Cat),
    io.write_string(Cat ++ "\n", !IO).
