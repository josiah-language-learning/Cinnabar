:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.

:- pred double(int::in, int::out) is det.
double(X, Y) :- Y = X * 2.

:- inst int_transform == (pred(in, out) is det).

% FIX: explicit inst annotation on Transform
:- pred apply_first(list(int)::in, pred(int, int)::in(int_transform),
                    list(int)::out) is det.
apply_first(Inputs, Transform, Outputs) :-
    list.map(Transform, Inputs, Outputs).

main(!IO) :-
    Inputs = [1, 2, 3, 4, 5],
    apply_first(Inputs, double, Doubled),
    io.write_line(Doubled, !IO).
