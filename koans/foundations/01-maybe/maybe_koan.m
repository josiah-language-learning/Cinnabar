:- module maybe_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module maybe.

% BUG: double_it is declared as a pred, but map_maybe expects a func.
:- pred double_it(int::in, int::out) is det.
double_it(X, Y) :- Y = X * 2.

main(!IO) :-
    MaybeN = yes(21),
    % TYPE ERROR: map_maybe expects func(int) = int, not pred(int, int)
    MaybeDoubled = map_maybe(double_it, MaybeN),
    (
        MaybeDoubled = yes(N),
        io.format("Result: %d\n", [i(N)], !IO)
    ;
        MaybeDoubled = no,
        io.write_string("No value\n", !IO)
    ).
