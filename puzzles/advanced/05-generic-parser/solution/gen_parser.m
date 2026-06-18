:- module gen_parser.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module char.
:- import_module int.
:- import_module list.
:- import_module string.

%---------------------------------------------------------------------------%
% The token_stream typeclass.
% S = stream type, T = token type.
% Mercury requires instance type arguments to be type variables or nullary
% type constructors, so we use newtype wrappers (cstream, tstream) rather
% than bare list(char) and list(token).

:- typeclass token_stream(S, T) where [
    pred next_token(T, S, S),
    mode next_token(out, in, out) is semidet
].

%---------------------------------------------------------------------------%
% Instance 1: character stream (newtype wrapping list(char))

:- type cstream ---> cstream(list(char)).

:- instance token_stream(cstream, char) where [
    pred(next_token/3) is cs_next
].

:- pred cs_next(char::out, cstream::in, cstream::out) is semidet.
cs_next(C, cstream([C | Rest]), cstream(Rest)).

%---------------------------------------------------------------------------%
% Instance 2: pre-lexed token stream (newtype wrapping list(token))

:- type token ---> tok_int(int) ; tok_plus ; tok_minus ; tok_star.

:- type tstream ---> tstream(list(token)).

:- instance token_stream(tstream, token) where [
    pred(next_token/3) is ts_next
].

:- pred ts_next(token::out, tstream::in, tstream::out) is semidet.
ts_next(T, tstream([T | Rest]), tstream(Rest)).

%---------------------------------------------------------------------------%
% Generic combinators.
%
% satisfy requires <= token_stream(S, T) because it calls next_token.
% many_p does NOT require the constraint — it only calls its predicate
% argument, so it is useful over any state type, not just token streams.

:- pred satisfy(pred(T), T, S, S) <= token_stream(S, T).
:- mode satisfy(in(pred(in) is semidet), out, in, out) is semidet.
satisfy(P, Tok, !S) :-
    next_token(Tok, !S),
    call(P, Tok).

:- pred many_p(pred(T, S, S), list(T), S, S).
:- mode many_p(in(pred(out, in, out) is semidet), out, in, out) is det.
many_p(P, Results, !S) :-
    ( call(P, V, !S) ->
        many_p(P, Rest, !S),
        Results = [V | Rest]
    ;
        Results = []
    ).

%---------------------------------------------------------------------------%
% Char-stream parsers (built with satisfy + many_p over the cstream instance)

:- pred is_digit_char(char::in) is semidet.
is_digit_char(C) :- char.is_digit(C).

:- pred parse_number(int::out, cstream::in, cstream::out) is det.
parse_number(N, !S) :-
    many_p(satisfy(is_digit_char), Cs, !S),
    ( Cs = [] ->
        N = 0
    ;
        ( string.to_int(string.from_char_list(Cs), N0) ->
            N = N0
        ;
            N = 0
        )
    ).

%---------------------------------------------------------------------------%
% Token-stream parsers (same combinators, tstream instance)

:- pred is_tok_int(token::in) is semidet.
is_tok_int(tok_int(_)).

:- pred tok_to_int(token::in, int::out) is semidet.
tok_to_int(tok_int(N), N).

:- pred collect_leading_ints(list(int)::out, tstream::in, tstream::out) is det.
collect_leading_ints(Ns, !S) :-
    many_p(satisfy(is_tok_int), Toks, !S),
    list.filter_map(tok_to_int, Toks, Ns).

%---------------------------------------------------------------------------%

main(!IO) :-
    io.write_string("=== char stream: parse_number ===\n", !IO),
    list.foldl(
        (pred(Str::in, !.IO::di, !:IO::uo) is det :-
            parse_number(N, cstream(string.to_char_list(Str)), cstream(Rem)),
            io.format("  \"%s\" => %d  rest=\"%s\"\n",
                [s(Str), i(N), s(string.from_char_list(Rem))], !IO)),
        ["314abc", "abc", "0", ""], !IO),

    io.nl(!IO),
    io.write_string("=== token stream: collect_leading_ints ===\n", !IO),
    Toks = [tok_int(3), tok_int(7), tok_plus, tok_int(1), tok_star],
    collect_leading_ints(Ns, tstream(Toks), tstream(TokRem)),
    NStrs = list.map(string.int_to_string, Ns),
    io.format("  leading ints: [%s]  remaining: %d token(s)\n",
        [s(string.join_list(", ", NStrs)), i(list.length(TokRem))], !IO),

    io.nl(!IO),
    io.write_string("=== same many_p + satisfy, both instances ===\n", !IO),
    many_p(satisfy(is_digit_char), DigCs,
        cstream(string.to_char_list("987xyz")), _),
    io.format("  char digits: \"%s\"\n",
        [s(string.from_char_list(DigCs))], !IO),
    many_p(satisfy(is_tok_int), IntToks,
        tstream([tok_int(5), tok_int(2), tok_plus, tok_int(9)]), _),
    io.format("  token ints collected: %d\n", [i(list.length(IntToks))], !IO).
