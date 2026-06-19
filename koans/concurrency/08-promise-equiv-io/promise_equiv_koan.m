:- module promise_equiv_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module list.
:- import_module string.
:- import_module thread.

:- pred worker(int::in, io::di, io::uo) is cc_multi.
worker(Id, !IO) :-
    io.format("worker %d\n", [i(Id)], !IO).

% BUG: thread.spawn is cc_multi; launch is declared det but will be inferred cc_multi.
% The cc_multi determinism propagates from the spawn call to launch.
:- pred launch(int::in, io::di, io::uo) is det.
launch(Id, !IO) :-
    thread.spawn(worker(Id), !IO).

main(!IO) :-
    launch(1, !IO),
    launch(2, !IO),
    io.write_string("done\n", !IO).
