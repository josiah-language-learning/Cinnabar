:- module unique_clobber.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module array.
:- import_module bool.
:- import_module int.
:- import_module list.

% FIX: produce the array in BOTH branches. The uo mode requires that A is
% initialized (uniquely bound) on every path through the predicate.
:- pred make_array(bool::in, array(int)::array_uo) is det.
make_array(Flag, A) :-
    ( Flag = yes ->
        array.init(5, 0, A)
    ;
        array.init(5, -1, A)   % A is now initialized in both branches
    ).

main(!IO) :-
    make_array(yes, A),
    io.write_line(A, !IO).
