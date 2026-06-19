:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module string.

% Fix: promise_pure asserts this foreign predicate is a pure function.
:- pred c_square(int::in, int::out) is det.
:- pragma foreign_proc("C",
    c_square(N::in, Result::out),
    [will_not_call_mercury, thread_safe, promise_pure],
    "
        Result = N * N;
    ").

:- pred describe_square(int::in, string::out) is det.
describe_square(N, Desc) :-
    c_square(N, Sq),
    ( Sq > 100 ->
        Desc = "large square"
    ;
        Desc = "small square"
    ).

main(!IO) :-
    describe_square(12, D),
    io.write_string(D ++ "\n", !IO).
