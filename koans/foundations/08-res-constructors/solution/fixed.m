:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module string.

main(!IO) :-
    io.open_input("data.txt", Result, !IO),
    ( Result = ok(Stream) ->
        io.read_file_as_string(Stream, Contents, !IO),
        ( Contents = ok(Str) ->
            io.write_string(Str, !IO)
        ;
            io.write_string("read error\n", !IO)
        )
    ;
        io.write_string("could not open file\n", !IO)
    ).
