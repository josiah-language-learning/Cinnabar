:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module map.
:- import_module string.

% An inst for a pure function (int) = int.
:- inst int_fn == (func(in) = out is det).

% A dispatch table maps string keys to int→int functions.
:- type dispatch_table == map(string, func(int) = int).

% build_table: construct a dispatch table with named operations.
% The functions should be: "double" -> *2, "square" -> ^2, "negate" -> negation.
:- func build_table = dispatch_table.
build_table = map.init.   % stub: add entries

% apply_op: look up a named operation and apply it to a value.
% Returns `no` if the operation name is unknown.
:- func apply_op(dispatch_table, string, int) = maybe(int).
apply_op(_, _, _) = no.  % stub

:- import_module maybe.

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    T = build_table,
    check("double 5 = 10",
          ( apply_op(T, "double", 5) = yes(10) -> yes ; no ), !IO),
    check("square 4 = 16",
          ( apply_op(T, "square", 4) = yes(16) -> yes ; no ), !IO),
    check("negate 7 = -7",
          ( apply_op(T, "negate", 7) = yes(-7) -> yes ; no ), !IO),
    check("unknown op = no",
          ( apply_op(T, "bogus",  1) = no       -> yes ; no ), !IO).
