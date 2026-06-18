:- module typeclass_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module list.
:- import_module string.
:- import_module int.

:- typeclass showable(T) where [
    func show(T) = string
].

:- instance showable(int) where [
    show(N) = string.int_to_string(N)
].

% BUG: instance for list(int) is a concrete instantiation.
% Mercury requires instance parameters to be type variables or
% concrete (not partially applied) types.
:- instance showable(list(int)) where [
    show(Ns) = "[" ++ string.join_list(", ", list.map(show, Ns)) ++ "]"
].

main(!IO) :-
    io.write_string(show(42) ++ "\n", !IO),
    io.write_string(show([1, 2, 3]) ++ "\n", !IO).
