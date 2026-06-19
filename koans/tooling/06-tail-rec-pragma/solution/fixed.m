:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.

% FIX: rewrite sum_list to use an accumulator so the recursive call
% is the last operation in every clause — genuinely tail-recursive.
:- pragma require_tail_recursion(sum_list/2, [error]).
:- pred sum_list(list(int)::in, int::out) is det.
sum_list(Xs, Sum) :- sum_list_acc(Xs, 0, Sum).

:- pred sum_list_acc(list(int)::in, int::in, int::out) is det.
sum_list_acc([], Acc, Acc).
sum_list_acc([X|Xs], Acc, Sum) :-
    sum_list_acc(Xs, Acc + X, Sum).   % recursive call is last — tail recursive

main(!IO) :-
    sum_list([1, 2, 3, 4, 5], S),
    io.write_int(S, !IO),
    io.nl(!IO).
