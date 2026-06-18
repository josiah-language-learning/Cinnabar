:- module client.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module utils.
% Note: client does NOT import string directly.
% But it uses string.length — this only works because utils.m
% accidentally re-exports string via import_module in its interface.

main(!IO) :-
    utils.format_greeting("world", G),
    io.write_string(G ++ "\n", !IO),
    % BUG: relies on transitive re-export of string from utils
    Len = string.length(G),
    io.format("Length: %d\n", [i(Len)], !IO).
