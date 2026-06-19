:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module list.
:- import_module string.

main(!IO) :-
    io.open_input("nonexistent.txt", Res, !IO),
    (
        Res = ok(Stream),
        io.read_line_as_string(Stream, _, !IO),
        io.close_input(Stream, !IO)
    ;
        Res = error(E),
        io.error_message(E, Msg),
        io.format("Error: %s\n", [s(Msg)], !IO)
    ).
