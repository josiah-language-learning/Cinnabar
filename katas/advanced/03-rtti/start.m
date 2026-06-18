:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module deconstruct.
:- import_module int.
:- import_module list.
:- import_module string.
:- import_module type_desc.
:- import_module univ.

% pretty_print: produce a structured string representation of any value
% using RTTI (deconstruct.deconstruct/5).
%
% deconstruct.deconstruct(Value, NonCanon, Functor, Arity, Args)
%   Value     — the value to inspect (any type)
%   NonCanon  — how to handle non-canonical terms (use `canonicalize`)
%   Functor   — output: the constructor name as a string
%   Arity     — output: the number of arguments
%   Args      — output: list of univ (each argument wrapped)
:- func pretty_print(T) = string.
pretty_print(_) = "???".   % stub: use deconstruct.deconstruct, recurse into args

% pretty_univ: unwrap a univ and recursively pretty_print it.
:- func pretty_univ(univ) = string.
pretty_univ(U) = Str :-
    ( univ_to_type(U, I : int) ->
        Str = string.int_to_string(I)
    ; univ_to_type(U, S : string) ->
        Str = "\"" ++ S ++ "\""
    ;
        % Fall through to generic RTTI path
        deconstruct.deconstruct(univ.univ_value(U),
                                canonicalize, F, _Ar, SubArgs),
        ( SubArgs = [] ->
            Str = F
        ;
            Str = F ++ "(" ++
                  string.join_list(", ", list.map(pretty_univ, SubArgs)) ++
                  ")"
        )
    ).

:- type colour ---> red ; green ; blue.
:- type point  ---> point(int, int).

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % Visual output — RTTI often produces implementation-dependent strings,
    % so we only check structural properties.
    io.format("pretty_print(42) = %s\n",
              [s(pretty_print(42))], !IO),
    io.format("pretty_print(red) = %s\n",
              [s(pretty_print(red))], !IO),
    io.format("pretty_print(point(3,4)) = %s\n",
              [s(pretty_print(point(3,4)))], !IO),
    io.format("pretty_print([1,2,3]) = %s\n",
              [s(pretty_print([1,2,3]))], !IO),
    check("pretty_print not empty",
          ( pretty_print(red) \= "" -> yes ; no ), !IO).
