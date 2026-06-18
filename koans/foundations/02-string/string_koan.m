:- module string_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module string.

% BUG: uses string.length (byte count) as if it were a codepoint count.
% Works for ASCII but silently wrong for multi-byte UTF-8 characters.
:- func truncate_to(string, int) = string.
truncate_to(S, MaxLen) =
    ( string.length(S) =< MaxLen ->
        S
    ;
        % BUG: string.left uses byte offset, not codepoint offset.
        % For "héllo", this may cut inside a multi-byte sequence.
        string.left(S, MaxLen)
    ).

main(!IO) :-
    Ascii = "hello world",
    NonAscii = "héllo",    % é is U+00E9, encoded as 2 bytes in UTF-8
    io.format("ASCII truncated: '%s'\n",
        [s(truncate_to(Ascii, 5))], !IO),
    io.format("Non-ASCII truncated: '%s'\n",
        [s(truncate_to(NonAscii, 5))], !IO).
    % Expected non-ASCII output: "héllo" (5 codepoints, only cut if > 5)
    % Actual output: may be garbled or truncated at wrong position
