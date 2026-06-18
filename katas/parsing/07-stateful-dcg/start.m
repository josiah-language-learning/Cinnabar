:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module char.
:- import_module int.
:- import_module list.
:- import_module map.
:- import_module pair.
:- import_module string.

% STATEFUL DCGs:
%
% DCG rules desugar to predicates with two hidden list arguments (input/output).
% You can add extra arguments to thread additional state through the grammar.
% The Mercury !State notation works inside DCG rules — it desugars to extra args.
%
% A DCG rule:
%   token(T, !Pos) --> [C], { update_pos(C, !Pos) }, ...
% desugars to:
%   token(T, Pos0, Pos, Input0, Input) :-
%       Input0 = [C | Input1], update_pos(C, Pos0, Pos1), ...

% ---- Exercise 1: position-tracking tokenizer ------------------------------
%
% pos: line and column numbers (1-based).

:- type pos ---> pos(line :: int, col :: int).

:- func pos_init = pos.
pos_init = pos(1, 1).

:- pred advance(char::in, pos::in, pos::out) is det.
advance(C, pos(L, Co), Next) :-
    ( C = '\n' ->
        Next = pos(L + 1, 1)
    ;
        Next = pos(L, Co + 1)
    ).

% token_with_pos: tokenize a list(char) while tracking position.
% Returns each character paired with its position.
% (Simplified: just track position per character rather than per token.)

:- pred chars_with_pos(list(char)::in, list(pair(char, pos))::out) is det.
chars_with_pos(Chars, Pairs) :-
    chars_with_pos_acc(Chars, pos_init, [], Pairs0),
    list.reverse(Pairs0, Pairs).

:- pred chars_with_pos_acc(list(char)::in, pos::in,
                           list(pair(char, pos))::in,
                           list(pair(char, pos))::out) is det.
chars_with_pos_acc([], _, Acc, Acc).
chars_with_pos_acc([C | Cs], Pos, Acc, Result) :-
    advance(C, Pos, NextPos),
    chars_with_pos_acc(Cs, NextPos, [C - Pos | Acc], Result).

% ---- Exercise 2: symbol-table-aware DCG -----------------------------------
%
% A simplistic expression parser that looks up identifiers in a symbol table.
% If an identifier is unknown, it returns a default value (0) instead of failing.
%
% symtable: variable name → int value

:- type symtable == map(string, int).

% lookup_var: look up a variable in the symbol table.
% Returns ok(N) if found, error("undefined: X") if not.
:- type lookup_result ---> ok(int) ; undefined(string).

:- pred lookup_var(string::in, symtable::in, lookup_result::out) is det.
lookup_var(Name, Table, Result) :-
    ( map.search(Table, Name, V) ->
        Result = ok(V)
    ;
        Result = undefined(Name)
    ).

% eval_with_table: evaluate a simple expression with variable lookup.
% Expressions: just single variable names or integer literals (stub).
:- pred eval_with_table(string::in, symtable::in, lookup_result::out) is det.
eval_with_table(Expr, Table, Result) :-
    ( string.to_int(Expr, N) ->
        Result = ok(N)
    ;
        lookup_var(Expr, Table, Result)
    ).

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % Exercise 1: position tracking.
    chars_with_pos(string.to_char_list("ab\ncd"), Pairs),
    ( Pairs = [('a') - pos(1,1), ('b') - pos(1,2),
               ('\n') - pos(1,3), ('c') - pos(2,1),
               ('d') - pos(2,2)] ->
        check("position tracking: correct", yes, !IO)
    ;
        check("position tracking: correct", no, !IO)
    ),
    % Exercise 2: symbol table.
    Table = map.from_assoc_list(["x" - 42, "y" - 7]),
    eval_with_table("x", Table, R1),
    check("lookup x = 42", ( R1 = ok(42) -> yes ; no ), !IO),
    eval_with_table("z", Table, R2),
    check("lookup z = undefined", ( R2 = undefined("z") -> yes ; no ), !IO),
    eval_with_table("10", Table, R3),
    check("literal 10 = ok(10)", ( R3 = ok(10) -> yes ; no ), !IO),
    % Stub exercise: extend chars_with_pos to work as a DCG rule with !Pos
    % threading, so you can write: [C], { advance(C, !Pos) } directly in DCG syntax.
    io.write_string("(See README for the DCG-rule threading exercise.)\n", !IO).
