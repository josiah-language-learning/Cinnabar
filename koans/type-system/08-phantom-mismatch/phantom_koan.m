:- module phantom_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module float.
:- import_module list.
:- import_module string.

% Phantom type: the type parameter U does not appear in the constructor.
% It is used only for compile-time unit tracking.
:- type length(U) ---> length(float).
:- type km  ---> km.
:- type miles ---> miles.

% add_lengths requires both arguments to have the same unit U.
:- pred add_lengths(length(U)::in, length(U)::in, length(U)::out) is det.
add_lengths(length(X), length(Y), length(X + Y)).

% BUG: K has type length(km) and M has type length(miles).
% add_lengths requires both inputs to share the same phantom parameter U.
% Passing mixed units is a type error — the whole point of phantom types.
main(!IO) :-
    K = length(5.0) : length(km),
    M = length(3.2) : length(miles),
    add_lengths(K, M, length(Sum)),
    io.format("sum: %f\n", [f(Sum)], !IO).
