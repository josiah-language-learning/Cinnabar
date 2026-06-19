:- module spawn_propagate_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is cc_multi.

:- implementation.
:- import_module thread.
:- import_module string.

% BUG: launch_workers calls thread.spawn, which is cc_multi.
% Any predicate that calls a cc_multi predicate must itself be at least
% cc_multi — the committed-choice property propagates upward.
:- pred launch_workers(io::di, io::uo) is det.   % BUG: should be cc_multi
launch_workers(!IO) :-
    thread.spawn(
        (pred(IO0::di, IO::uo) is cc_multi :- io.write_string("worker\n", IO0, IO)),
        !IO).

main(!IO) :-
    launch_workers(!IO),
    io.write_string("main done\n", !IO).
