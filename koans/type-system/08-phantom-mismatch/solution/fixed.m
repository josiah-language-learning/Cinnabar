:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module float.
:- import_module list.
:- import_module string.

:- type length(U) ---> length(float).
:- type km    ---> km.
:- type miles ---> miles.

:- pred add_lengths(length(U)::in, length(U)::in, length(U)::out) is det.
add_lengths(length(X), length(Y), length(X + Y)).

% FIX: both arguments must share the same phantom unit.
% Convert M from miles to km first, or just use consistent units.
main(!IO) :-
    K = length(5.0) : length(km),
    M = length(3.0) : length(km),   % same unit as K
    add_lengths(K, M, length(Sum)),
    io.format("sum: %f\n", [f(Sum)], !IO).
