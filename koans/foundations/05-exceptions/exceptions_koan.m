:- module exceptions_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module string.

main(!IO) :-
    io.command_line_arguments(Args, !IO),
    ( Args = [Filename | _] ->
        % BUG: io.open_input returns io.res(io.text_input_stream), not
        % io.text_input_stream directly. This causes a type error.
        io.open_input(Filename, Stream, !IO),
        io.read_line_as_string(Stream, Result, !IO),
        (
            Result = ok(Line),
            io.write_string(Line, !IO)
        ;
            Result = eof,
            io.write_string("(empty file)\n", !IO)
        ;
            Result = error(E),
            io.format("Read error: %s\n", [s(io.error_message(E))], !IO)
        )
    ;
        io.write_string("Usage: exceptions_koan <file>\n", !IO)
    ).
