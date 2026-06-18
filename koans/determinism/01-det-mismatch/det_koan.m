:- module det_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.

% BUG: declared det, but the if-then-else has no else branch.
% Without an else, this can fail when N < 0, making it semidet.
:- pred abs_val(int::in, int::out) is det.
abs_val(N, Abs) :-
    ( N >= 0 ->
        Abs = N
    % Missing else branch — what happens when N < 0?
    ).

main(!IO) :-
    abs_val(5, A),
    abs_val(-3, B),
    io.format("abs(5) = %d, abs(-3) = %d\n", [i(A), i(B)], !IO).
