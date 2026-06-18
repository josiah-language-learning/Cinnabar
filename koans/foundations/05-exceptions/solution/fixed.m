:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module list.
:- import_module string.

main(!IO) :-
    io.command_line_arguments(Args, !IO),
    ( Args = [Filename | _] ->
        io.open_input(Filename, OpenRes, !IO),
        (
            OpenRes = ok(Stream),
            io.read_line_as_string(Stream, ReadRes, !IO),
            io.close_input(Stream, !IO),
            (
                ReadRes = ok(Line),
                io.write_string(Line, !IO)
            ;
                ReadRes = eof,
                io.write_string("(empty file)\n", !IO)
            ;
                ReadRes = error(E),
                io.format("Read error: %s\n", [s(io.error_message(E))], !IO)
            )
        ;
            OpenRes = error(Err),
            io.format("Cannot open '%s': %s\n",
                [s(Filename), s(io.error_message(Err))], !IO)
        )
    ;
        io.write_string("Usage: fixed <file>\n", !IO)
    ).
