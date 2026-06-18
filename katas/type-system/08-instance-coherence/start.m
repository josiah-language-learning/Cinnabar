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

% ===========================================================================
% The coherence rule
%
% Mercury permits at most ONE instance of a typeclass per type, globally.
% This is called "instance coherence". It prevents the same type having
% different behaviour depending on which module is in scope.
%
% In Haskell, "orphan instances" — instances defined in a module that imports
% neither the typeclass module nor the type module — are allowed but warned.
% In large codebases, two libraries can accidentally define conflicting orphan
% instances for the same type. The behaviour becomes unpredictable.
%
% Mercury forbids this at the language level: every instance must be defined
% in either the module that defines the typeclass OR the module that defines
% the type. Orphan instances are a compile error.
% ===========================================================================

% ---- Exercise 1: a printable hierarchy with coherence ---------------------

:- typeclass printable(T) where [
    func to_str(T) = string
].

:- instance printable(int) where [
    to_str(N) = string.int_to_string(N)
].
:- instance printable(float) where [
    to_str(F) = string.float_to_string(F)
].
:- instance printable(string) where [
    to_str(S) = S
].

% A list instance: depends on printable(T), wraps each element.
:- instance printable(list(T)) <= printable(T) where [
    to_str(Xs) = "[" ++ list_str(Xs) ++ "]"
].

:- func list_str(list(T)) = string <= printable(T).
list_str([]) = "".
list_str([X]) = to_str(X).
list_str([X, Y | Xs]) = to_str(X) ++ ", " ++ list_str([Y | Xs]).

% ---- Exercise 2: newtype wrappers for alternative representations ---------
%
% We want two printable representations for float:
%   - standard:   "3.14"
%   - scientific: "3.14e0"
%
% We cannot write two instances of printable(float).
% Solution: wrap float in a newtype for each representation.

:- type standard_float   ---> standard_float(float).
:- type scientific_float ---> scientific_float(float).

:- instance printable(standard_float) where [
    to_str(standard_float(F)) = string.float_to_string(F)
].
:- instance printable(scientific_float) where [
    to_str(scientific_float(F)) = to_scientific(F)
].

% Simplified stub: appends "e0". A real implementation would compute
% the correct exponent, but the point here is the newtype pattern, not formatting.
:- func to_scientific(float) = string.
to_scientific(F) = string.float_to_string(F) ++ "e0".

% ---- Exercise 3: a parametric wrapper -------------------------------------
%
% A general "tagged" wrapper: pair a value with a string tag.
% The tag does not change the printable instance but demonstrates that
% the instance is defined once, not once per tag value.

:- type tagged(T) ---> tagged(string, T).

:- instance printable(tagged(T)) <= printable(T) where [
    to_str(tagged(Tag, Val)) = Tag ++ ":" ++ to_str(Val)
].

% ---- Checks ---------------------------------------------------------------

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    check("to_str int",
        ( to_str(42) = "42" -> yes ; no ), !IO),
    check("to_str string",
        ( to_str("hello") = "hello" -> yes ; no ), !IO),
    check("to_str list(int)",
        ( to_str([1, 2, 3]) = "[1, 2, 3]" -> yes ; no ), !IO),
    check("to_str list empty",
        ( to_str([] : list(int)) = "[]" -> yes ; no ), !IO),
    check("to_str nested list",
        ( to_str([[1, 2], [3]]) = "[[1, 2], [3]]" -> yes ; no ), !IO),
    check("standard_float 3.14",
        ( to_str(standard_float(3.14)) = string.float_to_string(3.14) -> yes ; no ), !IO),
    check("scientific_float 0.0",
        ( to_str(scientific_float(0.0)) = "0.0e0" -> yes ; no ), !IO),
    check("tagged int",
        ( to_str(tagged("score", 99)) = "score:99" -> yes ; no ), !IO),
    check("tagged string",
        ( to_str(tagged("name", "alice")) = "name:alice" -> yes ; no ), !IO).
