:- module foldl_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module string.

% Sum a list using foldl.
%
% BUG: !Acc is not allowed as a lambda argument — lambda heads require
% explicit ::in / ::out mode annotations on separate variables.
% The !X shorthand is only valid in *call* positions, not in lambda heads.
% The fix uses the N0/N naming convention: Acc0::in for the old value,
% Acc::out for the new value.
:- pred sum_list(list(int)::in, int::out) is det.
sum_list(Xs, Total) :-
    list.foldl(
        (pred(X::in, !Acc) is det :-     % BUG: !Acc not allowed in lambda head
            !:Acc = !.Acc + X),
        Xs, 0, Total).

main(!IO) :-
    sum_list([1, 2, 3, 4, 5], Total),
    io.format("sum: %d\n", [i(Total)], !IO).
