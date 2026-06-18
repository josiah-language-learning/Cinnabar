:- module dcg_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module char.
:- import_module list.
:- import_module string.

% BUG: (char.is_digit(C)) is treated as a grammar rule call.
% The DCG expander passes two extra list-difference args to char.is_digit,
% causing an arity error.
:- pred digit(char, list(char), list(char)).
:- mode digit(out, in, out) is semidet.

digit(C) --> [C], (char.is_digit(C)).

main(!IO) :-
    Input = string.to_char_list("123abc"),
    ( digit(D, Input, _Rest) ->
        io.format("First digit: %c\n", [c(D)], !IO)
    ;
        io.write_string("No digit found\n", !IO)
    ).
