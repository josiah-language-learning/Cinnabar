:- module fixed.
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

% FIX: instance for list(T) with constraint, not list(int)
:- instance showable(list(T)) <= showable(T) where [
    show(Ns) = "[" ++ string.join_list(", ", list.map(show, Ns)) ++ "]"
].

main(!IO) :-
    io.write_string(show(42) ++ "\n", !IO),
    io.write_string(show([1, 2, 3]) ++ "\n", !IO).
