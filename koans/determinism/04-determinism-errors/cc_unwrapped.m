:- module cc_unwrapped.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module thread.

% BUG: declared det, but spawns a thread using thread.spawn which is cc_multi.
% Any predicate that calls a cc_multi predicate must itself be cc_multi
% (or wrap the call in promise_equivalent_solutions).
% The fix: change the declaration to is cc_multi, or if you genuinely need
% det, wrap with cc_multi.promise_equivalent_solutions.
:- pred launch_worker(io::di, io::uo) is det.
launch_worker(!IO) :-
    thread.spawn(
        pred(IO0::di, IO1::uo) is cc_multi :-
            io.write_string("worker done\n", IO0, IO1),
        !IO).

main(!IO) :-
    launch_worker(!IO),
    io.write_string("launched\n", !IO).
