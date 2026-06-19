:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is cc_multi.

:- implementation.
:- import_module thread.
:- import_module string.

:- pred worker(io::di, io::uo) is cc_multi.   % fixed: cc_multi to match spawn's expectation
worker(!IO) :-
    io.write_string("hello from worker\n", !IO).

main(!IO) :-
    thread.spawn(worker, !IO),
    io.write_string("hello from main\n", !IO).
