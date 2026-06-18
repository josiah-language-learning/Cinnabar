:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module char.
:- import_module float.
:- import_module int.
:- import_module list.
:- import_module string.

% ===========================================================================
% Exercise 1: Typeclass approach — serializable
%
% Use a typeclass when:
%   - multiple related operations must be implemented consistently
%   - the instance is reusable across the codebase without being passed explicitly
%   - you want constraint propagation through types
% ===========================================================================

:- typeclass serializable(T) where [
    func serialize(T) = string
].

:- instance serializable(int) where [
    serialize(N) = string.int_to_string(N)
].
:- instance serializable(float) where [
    serialize(F) = string.float_to_string(F)
].
:- instance serializable(string) where [
    serialize(S) = "\"" ++ S ++ "\""
].

:- func serialize_list(list(T)) = string <= serializable(T).
serialize_list([]) = "[]".
serialize_list([X | Xs]) = "[" ++ serialize(X) ++ serialize_rest(Xs) ++ "]".

:- func serialize_rest(list(T)) = string <= serializable(T).
serialize_rest([]) = "".
serialize_rest([X | Xs]) = ", " ++ serialize(X) ++ serialize_rest(Xs).

% ===========================================================================
% Exercise 2: Higher-order approach — same problem, different design
%
% Use higher-order when:
%   - you need a single operation
%   - you want to swap implementations at runtime
%   - the predicate is local to a function
% ===========================================================================

:- func ho_serialize_list(func(T) = string, list(T)) = string.
ho_serialize_list(_, []) = "[]".
ho_serialize_list(F, [X | Xs]) = "[" ++ F(X) ++ ho_serialize_rest(F, Xs) ++ "]".

:- func ho_serialize_rest(func(T) = string, list(T)) = string.
ho_serialize_rest(_, []) = "".
ho_serialize_rest(F, [X | Xs]) = ", " ++ F(X) ++ ho_serialize_rest(F, Xs).

% ===========================================================================
% Exercise 3: Instance proliferation and newtype wrappers
%
% Problem: we want two different serializations of the same underlying type.
%   decimal(42) → "42"     (decimal notation)
%   hex(42)     → "0x2a"   (hexadecimal notation)
%
% We cannot write two instances of serializable(int) — that violates coherence.
% Solution: wrap int in a newtype. Each wrapper gets its own distinct instance.
% ===========================================================================

:- type decimal ---> decimal(int).
:- type hex     ---> hex(int).

:- instance serializable(decimal) where [
    serialize(decimal(N)) = string.int_to_string(N)
].
:- instance serializable(hex) where [
    serialize(hex(N)) = "0x" ++ int_to_hex_str(N)
].

:- func int_to_hex_str(int) = string.
int_to_hex_str(N) = ( N =< 0 -> "0" ; int_to_hex_pos(N) ).

:- func int_to_hex_pos(int) = string.
int_to_hex_pos(N) =
    ( N = 0 -> ""
    ; int_to_hex_pos(N // 16) ++ string.char_to_string(hex_digit(N rem 16))
    ).

:- func hex_digit(int) = char.
hex_digit(N) = C :-
    ( N = 0  -> C = '0' ; N = 1  -> C = '1' ; N = 2  -> C = '2'
    ; N = 3  -> C = '3' ; N = 4  -> C = '4' ; N = 5  -> C = '5'
    ; N = 6  -> C = '6' ; N = 7  -> C = '7' ; N = 8  -> C = '8'
    ; N = 9  -> C = '9' ; N = 10 -> C = 'a' ; N = 11 -> C = 'b'
    ; N = 12 -> C = 'c' ; N = 13 -> C = 'd' ; N = 14 -> C = 'e'
    ; C = 'f'
    ).

% ===========================================================================
% Checks
% ===========================================================================

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    check("serialize int 42",
        ( serialize(42) = "42" -> yes ; no ), !IO),
    check("serialize string hi",
        ( serialize("hi") = "\"hi\"" -> yes ; no ), !IO),
    check("serialize_list [1,2,3]",
        ( serialize_list([1, 2, 3]) = "[1, 2, 3]" -> yes ; no ), !IO),
    check("serialize_list empty",
        ( serialize_list([] : list(int)) = "[]" -> yes ; no ), !IO),
    check("ho_serialize_list [1,2,3]",
        ( ho_serialize_list(
              (func(N) = string.int_to_string(N)),
              [1, 2, 3]) = "[1, 2, 3]" -> yes ; no ), !IO),
    check("serialize decimal(42) = \"42\"",
        ( serialize(decimal(42)) = "42" -> yes ; no ), !IO),
    check("serialize hex(42) = \"0x2a\"",
        ( serialize(hex(42)) = "0x2a" -> yes ; no ), !IO),
    check("serialize hex(255) = \"0xff\"",
        ( serialize(hex(255)) = "0xff" -> yes ; no ), !IO),
    check("serialize hex(0) = \"0x0\"",
        ( serialize(hex(0)) = "0x0" -> yes ; no ), !IO).
