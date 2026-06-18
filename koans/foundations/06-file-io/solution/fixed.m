:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module exception.
:- import_module list.
:- import_module string.
:- import_module unit.
:- import_module univ.

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
        % FIX: throw io.error directly; io.error_message is ambiguous
        % (both func and pred form exist), so calling it inline confuses
        % the type checker. Throw the io.error value; catch + decode in main.
        throw(E)
    ).

main(!IO) :-
    io.command_line_arguments(Args, !IO),
    ( Args = [Filename | _] ->
        io.open_input(Filename, OpenRes, !IO),
        (
            OpenRes = ok(Stream),
            % FIX: try_io captures exceptions; close_input always runs after
            promise_equivalent_solutions [Outcome, !:IO]
                exception.try_io(
                    (pred(unit::out, !.IO::di, !:IO::uo) is det :-
                        process_lines(Stream, !IO)),
                    Outcome, !IO),
            io.close_input(Stream, !IO),
            (
                Outcome = succeeded(_)
            ;
                Outcome = exception(Exn),
                ( univ_to_type(Exn, IoErr : io.error) ->
                    io.format("Error: %s\n", [s(io.error_message(IoErr))], !IO)
                ;
                    io.write_string("Error\n", !IO)
                )
            )
        ;
            OpenRes = error(Err),
            io.format("Cannot open: %s\n", [s(io.error_message(Err))], !IO)
        )
    ;
        io.write_string("Usage: fixed <file>\n", !IO)
    ).
