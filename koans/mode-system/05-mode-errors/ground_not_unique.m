:- module ground_not_unique.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module array.
:- import_module int.
:- import_module list.

% BUG: array.set requires the array argument to be unique (di mode).
% Here the same array is passed to two separate set calls, which would
% require the array to be aliased — two owners at once. Mercury's uniqueness
% system forbids this: a ground (in) array cannot be used as unique (di).
:- pred update_two(array(int)::array_di, int::in, int::in,
                   array(int)::array_uo) is det.
update_two(A0, X, Y, A) :-
    array.set(0, X, A0, A1),
    array.set(1, Y, A0, A).   % BUG: A0 was already consumed by the first set

main(!IO) :-
    A0 = array.from_list([0, 0, 0]),
    update_two(A0, 10, 20, A1),
    io.write_line(A1, !IO).
