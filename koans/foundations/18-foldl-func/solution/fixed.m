:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module string.

:- pred sum_list(list(int)::in, int::out) is det.
sum_list(List, Sum) :-
    list.foldl(pred(X::in, Acc0::in, Acc::out) is det :- Acc = Acc0 + X,
               List, 0, Sum).

main(!IO) :-
    sum_list([1, 2, 3, 4, 5], Sum),
    io.format("sum: %d\n", [i(Sum)], !IO).
