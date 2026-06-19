:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module string.

:- pred sum_list(list(int)::in, int::out) is det.
sum_list(Xs, Total) :-
    list.foldl(
        (pred(X::in, Acc0::in, Acc::out) is det :-
            Acc = Acc0 + X),
        Xs, 0, Total).

main(!IO) :-
    sum_list([1, 2, 3, 4, 5], Total),
    io.format("sum: %d\n", [i(Total)], !IO).
