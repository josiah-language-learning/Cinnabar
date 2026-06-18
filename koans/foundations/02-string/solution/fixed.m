:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module string.

:- func truncate_to(string, int) = string.
truncate_to(S, MaxLen) = Result :-
    CPCount = string.count_codepoints(S),
    ( CPCount =< MaxLen ->
        Result = S
    ;
        ( string.codepoint_offset(S, MaxLen, ByteOffset) ->
            Result = string.between(S, 0, ByteOffset)
        ;
            Result = S
        )
    ).

main(!IO) :-
    Ascii = "hello world",
    NonAscii = "héllo",
    io.format("ASCII truncated: '%s'\n",
        [s(truncate_to(Ascii, 5))], !IO),
    io.format("Non-ASCII truncated: '%s'\n",
        [s(truncate_to(NonAscii, 5))], !IO).
