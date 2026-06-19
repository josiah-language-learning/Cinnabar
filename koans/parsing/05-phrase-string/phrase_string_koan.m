:- module phrase_string_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module char.
:- import_module list.
:- import_module string.

% A DCG rule that consumes consecutive alphanumeric characters.
:- pred word_chars(list(char), list(char), list(char)).
:- mode word_chars(out, in, out) is det.
word_chars(Cs) -->
    ( [C], { char.is_alnum(C) } ->
        word_chars(Cs0), { Cs = [C | Cs0] }
    ;
        { Cs = [] }
    ).

% BUG: word_chars expects list(char) as its second argument (the input
% list), but Input here is a string.  DCG rules desugar to predicates
% on list(T) — strings must be converted first with string.to_char_list.
:- pred first_word(string::in, list(char)::out) is det.
first_word(Input, Word) :-
    word_chars(Word, Input, _).     % BUG: Input :: string, expected list(char)

main(!IO) :-
    first_word("hello world", Word),
    io.write_string(string.from_char_list(Word) ++ "\n", !IO).
