:- module uniqueness_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.

:- pred checkpoint(string::in, io::di, io::uo) is det.
checkpoint(Msg, !IO) :-
    io.write_string(Msg, !IO),
    io.write_string(Msg, !IO).

main(!IO) :-
    checkpoint("hello\n", !IO).
