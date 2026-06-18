:- module dcg_mode_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module char.
:- import_module list.
:- import_module string.

:- type token
    --->    word(string)
    ;       comma
    ;       period.

:- pred token(token, list(char), list(char)).
:- mode token(out, in, in) is semidet.      % BUG: last arg should be 'out'
token(T) -->
    [C],
    ( { char.is_alpha(C) } ->
        letters(Cs),
        { T = word(string.from_char_list([C | Cs])) }
    ; { C = (',') } ->
        { T = comma }
    ; { C = ('.') } ->
        { T = period }
    ;
        { fail }
    ).

:- pred letters(list(char), list(char), list(char)).
:- mode letters(out, in, out) is det.
letters(Cs) -->
    ( [C], { char.is_alpha(C) } ->
        letters(Cs0), { Cs = [C | Cs0] }
    ;
        { Cs = [] }
    ).

:- pred tokens(list(token), list(char), list(char)).
:- mode tokens(out, in, out) is det.
tokens(Ts) -->
    ( token(T) ->
        tokens(Ts0), { Ts = [T | Ts0] }
    ;
        { Ts = [] }
    ).

main(!IO) :-
    Input = string.to_char_list("hello,world."),
    tokens(Toks, Input, _),
    io.format("%d tokens\n", [i(list.length(Toks))], !IO).
