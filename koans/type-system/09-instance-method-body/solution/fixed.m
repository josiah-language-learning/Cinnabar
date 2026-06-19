:- module fixed.
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

:- instance drawable(shape) where [
    draw(S, !IO) :- draw_shape(S, !IO)
].

:- pred draw_shape(shape::in, io::di, io::uo) is det.
draw_shape(S, !IO) :-
    describe(S, Str),
    io.write_string(Str ++ "\n", !IO).

main(!IO) :-
    draw(circle(2.5), !IO),
    draw(rect(3.0, 4.0), !IO).
