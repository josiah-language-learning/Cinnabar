:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module char.
:- import_module list.
:- import_module string.

:- pred digit_char(char, list(char), list(char)).
:- mode digit_char(out, in, out) is semidet.
digit_char(C) --> [C], { char.is_digit(C) }.

% Fixed: declared semidet to match what digit_char can do.
:- pred parse_digit(string::in, char::out) is semidet.
parse_digit(Str, Digit) :-
    string.to_char_list(Str, Chars),
    digit_char(Digit, Chars, _).

main(!IO) :-
    ( parse_digit("7abc", D) ->
        io.write_char(D, !IO), io.nl(!IO)
    ;
        io.write_string("not a digit\n", !IO)
    ).
