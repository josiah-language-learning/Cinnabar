:- module tokenizer.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module char.
:- import_module int.
:- import_module list.
:- import_module string.

:- type token
    --->    int_tok(int)
    ;       plus
    ;       minus
    ;       star
    ;       slash.

:- pred tokenize(string::in, list(token)::out) is semidet.
tokenize(Input, Tokens) :-
    Chars = string.to_char_list(Input),
    token_list(Tokens, Chars, _).

% FIX: multiple clauses → if-then-else; one_token is semidet → det result
:- pred token_list(list(token), list(char), list(char)).
:- mode token_list(out, in, out) is det.
token_list(Tokens) -->
    whitespace,
    ( one_token(T) ->
        token_list(Ts), { Tokens = [T | Ts] }
    ;
        { Tokens = [] }
    ).

:- pred one_token(token, list(char), list(char)).
:- mode one_token(out, in, out) is semidet.
one_token(T) -->
    ( ['+'] ->
        { T = plus }
    ; ['-'] ->
        { T = minus }
    ; ['*'] ->
        { T = star }
    ; ['/'] ->
        { T = slash }
    ; ( [D], { char.is_digit(D) } ) ->
        digits(Ds),
        { string.to_int(string.from_char_list([D | Ds]), N) },
        { T = int_tok(N) }
    ;
        { fail }
    ).

% FIX: multiple clauses → if-then-else
:- pred digits(list(char), list(char), list(char)).
:- mode digits(out, in, out) is det.
digits(Ds) -->
    ( [D], { char.is_digit(D) } ->
        digits(Rest), { Ds = [D | Rest] }
    ;
        { Ds = [] }
    ).

% FIX: multiple clauses → if-then-else
:- pred whitespace(list(char), list(char)).
:- mode whitespace(in, out) is det.
whitespace -->
    ( [C], { char.is_whitespace(C) } ->
        whitespace
    ;
        { true }
    ).

main(!IO) :-
    Tests = ["1 + 2", "10 * 3 - 4", "100 / 5 + 2"],
    list.foldl(
        (pred(S::in, !.IO::di, !:IO::uo) is det :-
            ( tokenize(S, Tokens) ->
                io.format("%s => %d tokens\n", [s(S), i(list.length(Tokens))], !IO)
            ;
                io.format("%s => parse error\n", [s(S)], !IO)
            )),
        Tests, !IO).
