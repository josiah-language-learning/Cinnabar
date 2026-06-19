:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module string.

:- typeclass printable(T) where [
    pred do_print(T::in, io::di, io::uo) is det
].

:- typeclass describable(T) <= (printable(T)) where [
    pred describe(T::in, string::out) is det
].

:- type shape ---> circle(float) ; square(float).

% FIX: add instance printable(shape) first — required superclass instance.
% Multi-goal method bodies must delegate to a module-level predicate because
% commas inside `where [...]` separate items, not goals.
:- instance printable(shape) where [
    do_print(S, !IO) :- print_shape(S, !IO)
].

:- instance describable(shape) where [
    describe(circle(R), S) :- S = "circle r=" ++ string.float_to_string(R),
    describe(square(Side), S) :- S = "square side=" ++ string.float_to_string(Side)
].

:- pred print_shape(shape::in, io::di, io::uo) is det.
print_shape(S, !IO) :-
    describe(S, Str),
    io.write_string(Str ++ "\n", !IO).

main(!IO) :-
    describe(circle(3.0), Str),
    io.write_string(Str ++ "\n", !IO).
