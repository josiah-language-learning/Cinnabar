:- module fixed.
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

% Fixed: single clause with if-then-else — Mercury can determine this
% succeeds at most once (the branches are sequential tests, not simultaneous
% alternatives), giving the semidet declaration.
:- pred token(token, list(char), list(char)).
:- mode token(out, in, out) is semidet.
token(T) -->
    ( digit(_) ->
        { T = int_tok }
    ; ['+'] ->
        { T = plus_tok }
    ; ['*'] ->
        { T = star_tok }
    ;
        { fail }
    ).

main(!IO) :-
    Input = string.to_char_list("+"),
    ( token(T, Input, _) ->
        io.write(T, !IO), io.nl(!IO)
    ;
        io.write_string("no token\n", !IO)
    ).
