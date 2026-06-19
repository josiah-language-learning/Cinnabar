:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module string.

:- pred double_it(int::in, int::out) is det.
double_it(!N) :-
    !:N = !.N * 2.    % fixed: read from !.N (the current value)

main(!IO) :-
    double_it(21, Result),
    io.format("result: %d\n", [i(Result)], !IO).
