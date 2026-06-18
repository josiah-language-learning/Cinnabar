:- module ho_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module list.

:- pred double(int::in, int::out) is det.
double(X, Y) :- Y = X * 2.

% BUG: Transform has type pred(int, int) but no inst annotation.
% The compiler does not know the inst at the call/2 site.
:- pred apply_first(list(int)::in, pred(int, int)::in, list(int)::out) is det.
apply_first(Inputs, Transform, Outputs) :-
    list.map(Transform, Inputs, Outputs).

main(!IO) :-
    Inputs = [1, 2, 3, 4, 5],
    % MODE ERROR: Transform has inst 'ground' but list.map requires
    % the pred argument to have inst (pred(in, out) is det)
    apply_first(Inputs, double, Doubled),
    io.write_line(Doubled, !IO).
