:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is cc_multi.

:- implementation.
:- import_module thread.
:- import_module string.

:- pred launch_workers(io::di, io::uo) is cc_multi.   % fixed: cc_multi
launch_workers(!IO) :-
    thread.spawn(
        (pred(IO0::di, IO::uo) is cc_multi :- io.write_string("worker\n", IO0, IO)),
        !IO).

main(!IO) :-
    launch_workers(!IO),
    io.write_string("main done\n", !IO).
