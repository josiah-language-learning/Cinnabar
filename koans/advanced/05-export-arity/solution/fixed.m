:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- pred double(int::in, int::out) is det.
:- pred scale(int::in, int::in, int::out) is det.

:- implementation.
:- import_module int.

:- pragma foreign_export("C", double(in, out), "mercury_double").
double(X, Y) :- Y = X * 2.

% FIX: include all three argument modes — the export arity must match
% the predicate's declared arity exactly.
:- pragma foreign_export("C", scale(in, in, out), "mercury_scale").
scale(X, Factor, Y) :- Y = X * Factor.

main(!IO) :-
    double(5, D),
    io.write_int(D, !IO),
    io.nl(!IO).
