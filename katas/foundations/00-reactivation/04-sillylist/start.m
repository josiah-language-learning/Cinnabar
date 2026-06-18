:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module list.
:- import_module string.

% SillyList: using function names that shadow list constructors.
% In Mercury you CAN define functions named '[]' and '[|]' — they become
% ordinary functions, not new syntax.  This kata makes that visible.
%
% Implement these to produce a readable string representation of a "list":
%   nil_str should return something like "[]"
%   cons_str should produce something like "(H : T)"
:- func nil_str = string.
nil_str = "".   % stub

:- func cons_str(string, string) = string.
cons_str(_, _) = "".  % stub

% Using the two above, build_list should turn a Mercury list of strings
% into a single string representation by folding cons_str.
:- func build_list(list(string)) = string.
build_list([]) = nil_str.
build_list([H|T]) = cons_str(H, build_list(T)).

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    check("nil_str",      ( nil_str = "[]" -> yes ; no ), !IO),
    check("cons one",     ( cons_str("a", "[]") = "(a : [])" -> yes ; no ), !IO),
    check("build_list empty", ( build_list([]) = "[]" -> yes ; no ), !IO),
    check("build_list [a,b]",
          ( build_list(["a","b"]) = "(a : (b : []))" -> yes ; no ), !IO),
    io.nl(!IO),
    io.write_string("Visual: " ++ build_list(["x","y","z"]) ++ "\n", !IO).
