:- module shared_state_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.

main(!IO) :-
    (
        io.write_string("task A\n", !IO)
    &
        io.write_string("task B\n", !IO)
    ).
