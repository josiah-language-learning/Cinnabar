:- module spawn_det_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is cc_multi.

:- implementation.
:- import_module thread.
:- import_module string.

% BUG: worker is declared `det', but thread.spawn requires the callback
% predicate to have inst `pred(di, uo) is cc_multi'.
% `det' and `cc_multi' are different higher-order insts — the spawned
% closure must be annotated cc_multi to match the expected mode.
:- pred worker(io::di, io::uo) is det.
worker(!IO) :-
    io.write_string("hello from worker\n", !IO).

main(!IO) :-
    thread.spawn(worker, !IO),
    io.write_string("hello from main\n", !IO).
