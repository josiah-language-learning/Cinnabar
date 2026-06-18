:- module adt_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module float.

:- type shape
    --->    square(float)
    ;       rectangle(float, float)
    ;       triangle(float, float).   % base, height

% BUG: triangle constructor is not handled.
% Mercury will warn or error on this non-exhaustive switch.
:- func area(shape) = float.
area(square(S))        = S * S.
area(rectangle(W, H))  = W * H.
% Missing: area(triangle(B, H)) = ...

main(!IO) :-
    Shapes = [square(3.0), rectangle(4.0, 5.0), triangle(6.0, 2.0)],
    list.foldl(print_shape, Shapes, !IO).

:- pred print_shape(shape::in, io::di, io::uo) is det.
print_shape(S, !IO) :-
    io.format("Area: %.2f\n", [f(area(S))], !IO).
