:- module inference_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.

:- pred classify(int::in, string::out) is det.
classify(N, Category) :-
    % BUG: Threshold is used in the condition but only bound inside the branches.
    % Mode inference cannot reorder goals inside an if-then-else condition.
    ( N > Threshold ->
        Threshold = 100,       % Threshold bound here — too late for the condition
        Category = "high"
    ;
        Threshold = 100,       % also bound here — also too late
        Category = "low"
    ).

main(!IO) :-
    classify(150, Cat),
    io.write_string(Cat ++ "\n", !IO).
