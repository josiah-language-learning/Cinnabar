:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module list.
:- import_module string.

:- pred report(int::in, io::di, io::uo) is det.
report(N, !IO) :-
    io.format("count: %d\n", [i(N)], !IO).

main(!IO) :-
    report(42, !IO).
