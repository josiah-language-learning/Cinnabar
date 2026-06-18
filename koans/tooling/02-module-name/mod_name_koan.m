:- module greeting.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.

main(!IO) :-
    io.write_string("hello, Mercury\n", !IO).
