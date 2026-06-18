:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module maybe.
:- import_module string.

% FIX: declare as func, not pred
:- func double_it(int) = int.
double_it(X) = X * 2.

main(!IO) :-
    MaybeN = yes(21),
    MaybeDoubled = map_maybe(double_it, MaybeN),
    (
        MaybeDoubled = yes(N),
        io.format("Result: %d\n", [i(N)], !IO)
    ;
        MaybeDoubled = no,
        io.write_string("No value\n", !IO)
    ).
