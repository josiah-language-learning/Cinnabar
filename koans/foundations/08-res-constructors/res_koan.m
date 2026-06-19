:- module res_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module string.

% Open a file and print its contents.
%
% BUG: io.res/1 uses ok/error constructors, not yes/no.
% io.res(T) ---> ok(T) ; error(io.error).
% Matching with `yes' is a type error: `yes' belongs to maybe/1, not io.res/1.
main(!IO) :-
    io.open_input("data.txt", Result, !IO),
    ( Result = yes(Stream) ->
        io.read_file_as_string(Stream, Contents, !IO),
        ( Contents = ok(Str) ->
            io.write_string(Str, !IO)
        ;
            io.write_string("read error\n", !IO)
        )
    ;
        io.write_string("could not open file\n", !IO)
    ).
