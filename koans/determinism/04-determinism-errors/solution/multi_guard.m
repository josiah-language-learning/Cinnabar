:- module multi_guard.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module string.

% FIX: use if-then-else to make the clauses mutually exclusive.
% Each branch is taken at most once; N = 0 goes to the else branch of the first
% condition, and then the second condition determines the result.
:- pred categorize(int::in, string::out) is det.
categorize(N, Cat) :-
    ( N > 0 ->
        Cat = "positive"
    ; N < 0 ->
        Cat = "negative"
    ;
        Cat = "zero"
    ).

main(!IO) :-
    categorize(5, C1),
    io.write_string(C1, !IO),
    io.nl(!IO),
    categorize(-3, C2),
    io.write_string(C2, !IO),
    io.nl(!IO),
    categorize(0, C3),
    io.write_string(C3, !IO),
    io.nl(!IO).
