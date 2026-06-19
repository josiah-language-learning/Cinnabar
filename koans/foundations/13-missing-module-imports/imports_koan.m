:- module imports_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module list.
% Missing: import_module string.
% Without it, i(), s(), f(), c() constructors are undefined.

:- pred report(int::in, io::di, io::uo) is det.
report(N, !IO) :-
    io.format("count: %d\n", [i(N)], !IO).

main(!IO) :-
    report(42, !IO).
