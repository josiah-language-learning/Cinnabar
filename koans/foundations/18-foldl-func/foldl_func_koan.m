:- module foldl_func_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module string.

:- pred sum_list(list(int)::in, int::out) is det.
sum_list(List, Sum) :-
    % BUG: list.foldl expects pred(L, A, A), not func(L, A) = A.
    % A func lambda is a different type from a pred lambda.
    list.foldl(func(X, Acc) = Acc + X, List, 0, Sum).

main(!IO) :-
    sum_list([1, 2, 3, 4, 5], Sum),
    io.format("sum: %d\n", [i(Sum)], !IO).
