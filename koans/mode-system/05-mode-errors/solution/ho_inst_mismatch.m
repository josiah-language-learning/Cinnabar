:- module ho_inst_mismatch.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.

:- pred apply_to_list(pred(int, int), list(int), list(int)).
:- mode apply_to_list(pred(in, out) is det, in, out) is det.
apply_to_list(_, [], []).
apply_to_list(F, [X | Xs], [Y | Ys]) :-
    F(X, Y),
    apply_to_list(F, Xs, Ys).

% FIX: change double_if_even to det so it matches the expected pred(in, out) is det.
% The original semidet version can fail (for odd N); making it det requires a
% decision about what to produce for odd inputs.
:- pred double_or_zero(int::in, int::out) is det.
double_or_zero(N, D) :-
    ( N mod 2 = 0 -> D = N * 2 ; D = 0 ).

main(!IO) :-
    apply_to_list(double_or_zero, [2, 4, 6], Results),
    io.write_line(Results, !IO).
