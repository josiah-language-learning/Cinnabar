:- module cc_unwrapped.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is cc_multi.

:- implementation.
:- import_module thread.

% FIX: change the declaration to cc_multi, which propagates up to main.
% thread.spawn is cc_multi — any predicate calling it must also be cc_multi.
:- pred launch_worker(io::di, io::uo) is cc_multi.
launch_worker(!IO) :-
    thread.spawn(
        pred(IO0::di, IO1::uo) is cc_multi :-
            io.write_string("worker done\n", IO0, IO1),
        !IO).

main(!IO) :-
    launch_worker(!IO),
    io.write_string("launched\n", !IO).
