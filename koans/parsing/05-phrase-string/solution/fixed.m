:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module char.
:- import_module list.
:- import_module string.

:- pred word_chars(list(char), list(char), list(char)).
:- mode word_chars(out, in, out) is det.
word_chars(Cs) -->
    ( [C], { char.is_alnum(C) } ->
        word_chars(Cs0), { Cs = [C | Cs0] }
    ;
        { Cs = [] }
    ).

:- pred first_word(string::in, list(char)::out) is det.
first_word(Input, Word) :-
    string.to_char_list(Input, Chars),   % fixed: convert string to list(char)
    word_chars(Word, Chars, _).

main(!IO) :-
    first_word("hello world", Word),
    io.write_string(string.from_char_list(Word) ++ "\n", !IO).
