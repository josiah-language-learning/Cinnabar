:- module ho_inst_mismatch.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.

% BUG: apply_to_list expects a pred(int::in, int::out) is det,
% but double_if_even is semidet. The determinism inst of the higher-order
% argument doesn't match: expected `is det`, got `is semidet`.
:- pred apply_to_list(pred(int, int), list(int), list(int)).
:- mode apply_to_list(pred(in, out) is det, in, out) is det.
apply_to_list(_, [], []).
apply_to_list(F, [X | Xs], [Y | Ys]) :-
    F(X, Y),
    apply_to_list(F, Xs, Ys).

:- pred double_if_even(int::in, int::out) is semidet.
double_if_even(N, D) :-
    N mod 2 = 0,
    D = N * 2.

main(!IO) :-
    % BUG: passing a semidet pred where a det pred is required
    apply_to_list(double_if_even, [2, 4, 6], Results),
    io.write_line(Results, !IO).
