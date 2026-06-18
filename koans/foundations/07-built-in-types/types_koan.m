:- module types_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module string.

:- func average(int, int) = int.
% BUG: / is not defined for int. Use // instead.
average(A, B) = (A + B) / 2.

main(!IO) :-
    io.format("average(10, 3) = %d\n", [i(average(10, 3))], !IO),

    % Note: rem vs mod on negative numbers (logic error, not compile error)
    A = -7,
    B = 3,
    io.format("%d rem %d = %d\n", [i(A), i(B), i(A rem B)], !IO),
    io.format("%d mod %d = %d\n", [i(A), i(B), i(A mod B)], !IO).
