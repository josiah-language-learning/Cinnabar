:- module export_arity_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- pred double(int::in, int::out) is det.
:- pred scale(int::in, int::in, int::out) is det.

:- implementation.
:- import_module int.

:- pragma foreign_export("C", double(in, out), "mercury_double").
double(X, Y) :- Y = X * 2.

% BUG: scale/3 takes three arguments (in, in, out) but the pragma only
% specifies two modes (in, out). The export arity doesn't match the predicate.
:- pragma foreign_export("C", scale(in, out), "mercury_scale").
scale(X, Factor, Y) :- Y = X * Factor.

main(!IO) :-
    double(5, D),
    io.write_int(D, !IO),
    io.nl(!IO).
