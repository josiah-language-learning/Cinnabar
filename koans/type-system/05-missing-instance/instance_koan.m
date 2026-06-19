:- module instance_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module string.

:- typeclass show(T) where [
    pred show(T::in, string::out) is det
].

:- instance show(int) where [
    show(N, S) :- S = string.int_to_string(N)
].

:- type color ---> red ; green ; blue.

% BUG: no `instance show(color)' declared.
% Mercury cannot satisfy the typeclass constraint for a concrete type
% that has no instance — this is a compile-time error, not a runtime one.
:- pred print_color(color::in, io::di, io::uo) is det.
print_color(C, !IO) :-
    show(C, Str),
    io.write_string(Str ++ "\n", !IO).

main(!IO) :-
    print_color(red, !IO).
