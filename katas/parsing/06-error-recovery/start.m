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

% ERROR RECOVERY IN PARSERS:
%
% A semidet parser that fails gives no information about where or why.
% Better: return a structured result that includes error position and message.
%
%   parse_result(T) ---> ok(T) ; error(int, string)
%                        position ^    ^ message

:- type parse_result(T)
    --->    ok(T)
    ;       error(int, string).   % position, message

% ---- Exercise 1: tokenizer with structured errors --------------------------
%
% Token type for a tiny expression language.
:- type token
    --->    num(int)
    ;       plus
    ;       minus
    ;       times
    ;       divide
    ;       lparen
    ;       rparen.

% tokenize: scan a list(char) into list(token), returning position of first
% unexpected character if scanning fails.
:- pred tokenize(list(char)::in, parse_result(list(token))::out) is det.
tokenize(Chars, Result) :-
    tokenize_acc(Chars, 0, [], Result).

:- pred tokenize_acc(list(char)::in, int::in, list(token)::in,
                     parse_result(list(token))::out) is det.
tokenize_acc([], _Pos, Acc, ok(Rev)) :-
    list.reverse(Acc, Rev).
tokenize_acc([C | Cs], Pos, Acc, Result) :-
    ( C = ('+') ->
        tokenize_acc(Cs, Pos + 1, [plus | Acc], Result)
    ; C = ('-') ->
        tokenize_acc(Cs, Pos + 1, [minus | Acc], Result)
    ; C = ('*') ->
        tokenize_acc(Cs, Pos + 1, [times | Acc], Result)
    ; C = ('/') ->
        tokenize_acc(Cs, Pos + 1, [divide | Acc], Result)
    ; C = ('(') ->
        tokenize_acc(Cs, Pos + 1, [lparen | Acc], Result)
    ; C = (')') ->
        tokenize_acc(Cs, Pos + 1, [rparen | Acc], Result)
    ; char.is_whitespace(C) ->
        tokenize_acc(Cs, Pos + 1, Acc, Result)
    ; char.is_digit(C) ->
        ( char.decimal_digit_to_int(C, D) ->
            tokenize_acc(Cs, Pos + 1, [num(D) | Acc], Result)
        ;
            tokenize_acc(Cs, Pos + 1, [num(0) | Acc], Result)
        )
        % stub: accumulate multi-digit numbers (consume while is_digit)
    ;
        Msg = string.format("unexpected character '%c' at position %d",
                            [c(C), i(Pos)]),
        Result = error(Pos, Msg)
    ).

% ---- Exercise 2: recovery strategies --------------------------------------
%
% panic_mode: on error, skip tokens until a 'sync point' (here: rparen or eof),
% then continue. Returns ok([]) from the sync point onward.
:- pred panic_mode(list(char)::in, parse_result(list(token))::out) is det.
panic_mode(Chars, Result) :-
    tokenize(Chars, First),
    ( First = ok(_) ->
        Result = First
    ;
        % stub: find next ')' or end, tokenize the remainder
        Result = ok([])
    ).

% ---- Exercise 3: det top-level (errors as values) -------------------------
%
% parse_expr: parse an expression. Always det — parse errors become error(Pos, Msg).
:- pred parse_expr(list(token)::in, parse_result(int)::out) is det.
parse_expr(Tokens, Result) :-
    ( Tokens = [num(N) | _] ->
        Result = ok(N)   % stub: full expression parse
    ;
        Result = error(0, "expected number")
    ).

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % Tokenize a valid expression.
    tokenize(string.to_char_list("1 + 2"), R1),
    check("tokenize '1 + 2': ok",
        ( R1 = ok(_) -> yes ; no ), !IO),
    % Tokenize an invalid expression.
    tokenize(string.to_char_list("1 @ 2"), R2),
    check("tokenize '1 @ 2': error with position",
        ( R2 = error(2, _) -> yes ; no ), !IO),
    % parse_expr stub: single number.
    parse_expr([num(42)], R3),
    check("parse_expr [num(42)]: ok(42)",
        ( R3 = ok(42) -> yes ; no ), !IO),
    parse_expr([], R4),
    check("parse_expr []: error",
        ( R4 = error(_, _) -> yes ; no ), !IO).
