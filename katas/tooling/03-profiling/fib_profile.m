:- module fib_profile.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module string.

% fib_naive: classic doubly-recursive Fibonacci — exponential time.
% Profile this to see the explosion in calls.
:- func fib_naive(int) = int.
fib_naive(N) =
    ( N =< 1 -> N ; fib_naive(N - 1) + fib_naive(N - 2) ).

% fib_memo: same recurrence but with pragma memo — polynomial time.
% Step 1: compile with a profiling grade:
%   mmc --make --grade asm_fast.gc.profdeep fib_profile
% Step 2: run:
%   ./fib_profile
% Step 3: view deep profile:
%   mdprof_cgi fib_profile.data   (or mdprof_text for terminal output)
:- func fib_memo(int) = int.
:- pragma memo(fib_memo/1).
fib_memo(N) =
    ( N =< 1 -> N ; fib_memo(N - 1) + fib_memo(N - 2) ).

main(!IO) :-
    N = 30,
    Naive = fib_naive(N),
    Memo  = fib_memo(N),
    io.format("fib_naive(%d) = %d\n", [i(N), i(Naive)], !IO),
    io.format("fib_memo(%d)  = %d\n", [i(N), i(Memo)],  !IO),
    ( Naive = Memo ->
        io.write_string("Both agree.\n", !IO)
    ;
        io.write_string("MISMATCH!\n", !IO)
    ).
