:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module float.
:- import_module int.
:- import_module list.
:- import_module string.

% ---- Exercise 1: typeclass hierarchy with superclass constraints -----------
%
% printable(T) requires show(T) — you can only print things you can show as str.
% This means any instance of printable MUST also be an instance of show.

:- typeclass show(T) where [
    func show(T) = string
].

:- typeclass printable(T) <= show(T) where [
    pred print_item(T::in, io::di, io::uo) is det
].

% Instances for int.
:- instance show(int) where [
    show(N) = string.int_to_string(N)
].
:- instance printable(int) where [
    pred(print_item/3) is print_int
].
:- pred print_int(int::in, io::di, io::uo) is det.
print_int(N, !IO) :- io.write_string(show(N), !IO).   % uses show(T) from superclass

% Instances for string.
:- instance show(string) where [
    show(S) = "\"" ++ S ++ "\""
].
:- instance printable(string) where [
    pred(print_item/3) is print_str
].
:- pred print_str(string::in, io::di, io::uo) is det.
print_str(S, !IO) :- io.write_string(show(S), !IO).

% A predicate constrained by both the superclass chain.
% Note: declaring <= printable(T) also implies <= show(T) via the hierarchy.
:- pred show_and_print(T::in, io::di, io::uo) is det <= printable(T).
show_and_print(X, !IO) :-
    io.write_string(show(X), !IO),
    io.write_string(" → ", !IO),
    print_item(X, !IO),
    io.nl(!IO).

% ---- Exercise 2: multi-parameter typeclass with functional dependency ------
%
% convertible(From, To): From uniquely determines To.
% The FD `From -> To` means: for each From type, there is exactly one To type.
% Without FD: convert(int, _) is ambiguous — which To?

:- typeclass convertible(From, To) <= ((From -> To)) where [
    func convert(From) = To
].

:- instance convertible(int, string) where [
    convert(N) = string.int_to_string(N)
].
:- instance convertible(float, string) where [
    convert(F) = string.float_to_string(F)
].
% NOTE: Adding  instance convertible(int, float)  here would be a COMPILE ERROR
% because the FD (From -> To) allows only ONE To per From.
% int already maps to string; it cannot also map to float.

% A predicate using the FD: given an int, convert to To (FD determines To).
:- func as_string(T) = string <= convertible(T, string).
as_string(X) = convert(X).

% ---- Exercise 3: using the hierarchy from main ----------------------------

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % Exercise 1: superclass chain.
    check("show(42) = \"42\"",
        ( show(42) = "42" -> yes ; no ), !IO),
    check("show(\"hello\") = \"\\\"hello\\\"\"",
        ( show("hello") = "\"hello\"" -> yes ; no ), !IO),
    io.write_string("print_item int: ", !IO),
    print_item(99, !IO),
    io.nl(!IO),
    io.write_string("show_and_print string: ", !IO),
    show_and_print("world", !IO),
    % Exercise 2: convertible with FD.
    check("as_string 42 = \"42\"",
        ( as_string(42) = "42" -> yes ; no ), !IO),
    check("as_string 3.14 starts with \"3\"",
        ( string.prefix(as_string(3.14), "3") -> yes ; no ), !IO),
    % FD means convert(42) resolves to string without ambiguity.
    % FD means convert(42) resolves unambiguously to string (the only To for int).
    check("convert(42) = \"42\"",
        ( convert(42) = "42" -> yes ; no ), !IO),
    check("convert(3.14) starts with \"3\"",
        ( string.prefix(convert(3.14), "3") -> yes ; no ), !IO).
