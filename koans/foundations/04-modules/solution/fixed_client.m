:- module client.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module utils.
:- import_module string.   % FIX: explicitly import what we use

main(!IO) :-
    utils.format_greeting("world", G),
    io.write_string(G ++ "\n", !IO),
    Len = string.length(G),
    io.format("Length: %d\n", [i(Len)], !IO).
