:- module counter_client.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module list.
:- import_module string.
:- import_module counter.

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    C0 = counter.init(10),
    check("init: value = 10",
        ( counter.value(C0) = 10 -> yes ; no ), !IO),
    counter.increment(C0, C1),
    check("increment: value = 11",
        ( counter.value(C1) = 11 -> yes ; no ), !IO),
    counter.increment(C1, C2),
    counter.increment(C2, C3),
    check("two more increments: value = 13",
        ( counter.value(C3) = 13 -> yes ; no ), !IO),
    counter.decrement(C3, C4),
    check("decrement: value = 12",
        ( counter.value(C4) = 12 -> yes ; no ), !IO),
    counter.reset(C4, C5),
    check("reset: value = 0",
        ( counter.value(C5) = 0 -> yes ; no ), !IO).
    % To see the encapsulation error: try adding
    %   counter(N) = C0,
    % and observe the compiler message.
