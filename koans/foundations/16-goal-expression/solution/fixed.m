:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module list.
:- import_module string.

:- type flagged ---> flagged(bool).

:- func tag_equal(int, int) = flagged.
tag_equal(A, B) = Result :-
    ( A = B -> Result = flagged(yes) ; Result = flagged(no) ).

main(!IO) :-
    io.format("3 = 3: %s\n", [s(string.string(tag_equal(3, 3)))], !IO),
    io.format("3 = 4: %s\n", [s(string.string(tag_equal(3, 4)))], !IO).
