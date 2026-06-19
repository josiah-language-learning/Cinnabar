:- module dcg_nondet_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module char.
:- import_module list.
:- import_module string.

:- type token ---> int_tok ; plus_tok ; star_tok.

:- pred digit(char, list(char), list(char)).
:- mode digit(out, in, out) is semidet.
digit(C) --> [C], { char.is_digit(C) }.

% BUG: multi-clause DCG rules infer `nondet' — each clause is a separate
% alternative and Mercury cannot prove they are mutually exclusive at
% compile time.  Declared `semidet' but inferred `nondet'.
% Fix: collapse to a single clause with if-then-else inside the body.
:- pred token(token, list(char), list(char)).
:- mode token(out, in, out) is semidet.
token(int_tok) --> digit(_).
token(plus_tok) --> ['+'].
token(star_tok) --> ['*'].

main(!IO) :-
    Input = string.to_char_list("+"),
    ( token(T, Input, _) ->
        io.write(T, !IO), io.nl(!IO)
    ;
        io.write_string("no token\n", !IO)
    ).
