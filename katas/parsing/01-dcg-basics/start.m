:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module char.
:- import_module int.
:- import_module list.
:- import_module string.

% Token type for a tiny arithmetic expression grammar.
:- type token
    --->    tok_num(int)
    ;       tok_plus
    ;       tok_minus
    ;       tok_lparen
    ;       tok_rparen.

% tokenize: convert a char list to a token list.
% Written as a DCG rule (no phrase/2 in Mercury 22 — call directly).
:- pred tokenize(list(token)::out,
                 list(char)::in, list(char)::out) is semidet.
tokenize([]) --> [].   % stub: add cases for each token kind

% run_tokenize: wrapper that calls the DCG directly.
:- pred run_tokenize(string::in, list(token)::out) is semidet.
run_tokenize(Input, Tokens) :-
    tokenize(Tokens, string.to_char_list(Input), []).

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    ( run_tokenize("1+2", [tok_num(1), tok_plus, tok_num(2)]) ->
        check("tokenize 1+2", yes, !IO)
    ;
        check("tokenize 1+2", no, !IO)
    ),
    ( run_tokenize("(10-3)", [tok_lparen, tok_num(10), tok_minus, tok_num(3), tok_rparen]) ->
        check("tokenize (10-3)", yes, !IO)
    ;
        check("tokenize (10-3)", no, !IO)
    ),
    ( run_tokenize("", []) ->
        check("tokenize empty string", yes, !IO)
    ;
        check("tokenize empty string", no, !IO)
    ).
