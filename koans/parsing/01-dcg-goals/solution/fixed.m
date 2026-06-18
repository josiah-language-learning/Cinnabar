:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module char.
:- import_module list.
:- import_module string.

:- pred digit(char, list(char), list(char)).
:- mode digit(out, in, out) is semidet.

% FIX: { } wraps the Mercury goal without threading list-difference args
digit(C) --> [C], { char.is_digit(C) }.

main(!IO) :-
    Input = string.to_char_list("123abc"),
    ( digit(D, Input, _Rest) ->
        io.format("First digit: %c\n", [c(D)], !IO)
    ;
        io.write_string("No digit found\n", !IO)
    ).
