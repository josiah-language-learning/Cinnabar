:- module file_io_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module exception.
:- import_module string.

:- pred process_lines(io.text_input_stream::in, io::di, io::uo) is det.
process_lines(Stream, !IO) :-
    io.read_line_as_string(Stream, Res, !IO),
    (
        Res = ok(Line),
        io.write_string(Line, !IO),
        process_lines(Stream, !IO)
    ;
        Res = eof
    ;
        Res = error(E),
        % Simulating a read error by throwing
        throw(io.error_message(E))
    ).

main(!IO) :-
    io.command_line_arguments(Args, !IO),
    ( Args = [Filename | _] ->
        io.open_input(Filename, OpenRes, !IO),
        (
            OpenRes = ok(Stream),
            % BUG: if process_lines throws, io.close_input is never called.
            % The stream handle is leaked.
            process_lines(Stream, !IO),
            io.close_input(Stream, !IO)
        ;
            OpenRes = error(Err),
            io.format("Cannot open: %s\n", [s(io.error_message(Err))], !IO)
        )
    ;
        io.write_string("Usage: file_io_koan <file>\n", !IO)
    ).
