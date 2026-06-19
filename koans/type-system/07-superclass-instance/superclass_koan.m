:- module superclass_koan.
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

% BUG: declaring instance describable(shape) without instance printable(shape).
% describable requires printable as a superclass — the superclass instance
% must exist before the subclass instance can be accepted.
:- instance describable(shape) where [
    describe(circle(R), S) :- S = "circle r=" ++ string.float_to_string(R),
    describe(square(Side), S) :- S = "square side=" ++ string.float_to_string(Side)
].

main(!IO) :-
    describe(circle(3.0), S),
    io.write_string(S ++ "\n", !IO).
