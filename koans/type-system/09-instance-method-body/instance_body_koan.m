:- module instance_body_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- typeclass drawable(T) where [
    pred draw(T::in, io::di, io::uo) is det
].

:- type shape ---> circle(float) ; rect(float, float).
:- instance drawable(shape).

:- implementation.
:- import_module float.
:- import_module string.

:- pred describe(shape::in, string::out) is det.
describe(circle(R), "circle r=" ++ float_to_string(R)).
describe(rect(W, H), "rect " ++ float_to_string(W) ++ "x" ++ float_to_string(H)).

% BUG: the comma after describe(S, Str) is the where-list ITEM SEPARATOR,
% not a goal conjunction. io.write_string is parsed as a second instance item
% (a method named write_string, which is not a method of drawable).
:- instance drawable(shape) where [
    draw(S, !IO) :- describe(S, Str),
    io.write_string(Str ++ "\n", !IO)
].

main(!IO) :-
    draw(circle(2.5), !IO),
    draw(rect(3.0, 4.0), !IO).
