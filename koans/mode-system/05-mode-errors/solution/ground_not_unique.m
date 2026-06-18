:- module ground_not_unique.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module array.
:- import_module int.
:- import_module list.

% FIX: thread the array through the updates sequentially.
% A0 → (set 0) → A1 → (set 1) → A2
% Each array.set consumes one unique value and produces the next.
% No aliasing — each intermediate name is used exactly once.
:- pred update_two(array(int)::array_di, int::in, int::in,
                   array(int)::array_uo) is det.
update_two(A0, X, Y, A) :-
    array.set(0, X, A0, A1),
    array.set(1, Y, A1, A).

main(!IO) :-
    A0 = array.from_list([0, 0, 0]),
    update_two(A0, 10, 20, A1),
    io.write_line(A1, !IO).
