:- module fixed.
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

:- pred launch(int::in, io::di, io::uo) is det.
launch(Id, !IO) :-
    promise_equivalent_solutions [!:IO]
        thread.spawn(worker(Id), !IO).

main(!IO) :-
    launch(1, !IO),
    launch(2, !IO),
    io.write_string("done\n", !IO).
