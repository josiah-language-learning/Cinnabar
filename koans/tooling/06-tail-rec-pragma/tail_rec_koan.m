:- module tail_rec_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.

% BUG: pragma require_tail_recursion with [error] requires the predicate to be
% tail-recursive, but sum_list uses a call-then-add pattern:
%   sum_list(Xs, Rest) — recursive call
%   Sum = X + Rest     — uses Rest after the call returns
% The recursive call is NOT the last operation — adding is. This is a classic
% non-tail-recursive accumulate pattern.
:- pragma require_tail_recursion(sum_list/2, [error]).
:- pred sum_list(list(int)::in, int::out) is det.
sum_list([], 0).
sum_list([X|Xs], Sum) :-
    sum_list(Xs, Rest),
    Sum = X + Rest.

main(!IO) :-
    sum_list([1, 2, 3, 4, 5], S),
    io.write_int(S, !IO),
    io.nl(!IO).
