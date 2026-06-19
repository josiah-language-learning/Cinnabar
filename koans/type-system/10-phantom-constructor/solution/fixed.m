:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- type metres ---> metres_unit.
:- type seconds ---> seconds_unit.

:- type speed(Dist, Time) ---> speed(float).
:- func make_speed(float) = speed(metres, seconds).

:- implementation.

make_speed(V) = speed(V).

main(!IO) :-
    _S = make_speed(5.0),
    io.write_string("ok\n", !IO).
