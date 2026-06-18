:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module string.

% DETERMINISTIC PARALLELISM:
%
% `&` (parallel conjunction) guarantees that the parallel program produces the
% SAME LOGICAL RESULT as the sequential program. Both branches must be `det`
% or `cc_multi`. This is deterministic parallelism: the result is independent
% of scheduling.
%
% This contrasts with `thread.spawn` which creates true concurrency — the
% result can depend on thread interleaving (even if synchronized with mutvars).
%
% Mercury's par-conjunct analysis proves that two conjuncts don't share
% mutable state (beyond what they communicate via unique values). This is
% the structural guarantee that makes `&` sound.

% ---- Exercise 1: parallel divide-and-conquer sum --------------------------

:- pred range_sum(int::in, int::in, int::out) is det.
range_sum(Lo, Hi, Sum) :-
    ( Lo > Hi -> Sum = 0 ; range_sum(Lo + 1, Hi, Rest), Sum = Lo + Rest ).

:- pred par_sum(int::in, int::in, int::in, int::out) is det.
par_sum(Lo, Hi, Threshold, Sum) :-
    ( Lo > Hi ->
        Sum = 0
    ; Lo = Hi ->
        Sum = Lo
    ; Hi - Lo < Threshold ->
        range_sum(Lo, Hi, Sum)
    ;
        Mid = (Lo + Hi) / 2,
        ( par_sum(Lo, Mid, Threshold, Left)
        & par_sum(Mid + 1, Hi, Threshold, Right)
        ),
        Sum = Left + Right
    ).

% ---- Exercise 2: parallel pair of independent computations ----------------
%
% Two independent det predicates can run in parallel with &.
% Note: higher-order predicates in & can trigger a compiler bug in 22.01.8 —
% use named predicates for each branch.

:- pred square(int::in, int::out) is det.
square(X, Y) :- Y = X * X.

:- pred par_square2(int::in, int::in, int::out, int::out) is det.
par_square2(X, Y, SqX, SqY) :-
    ( square(X, SqX) & square(Y, SqY) ).

% ---- Exercise 3: `&` vs `spawn` — same result, different model ------------
%
% par_sum uses `&`: result is deterministic, no thread management needed.
% The parallel conjuncts share no mutable state; Mercury proves this.
%
% NOTE: Mercury 22.01.8 has a backend bug where function-call expressions
% in `&` conjuncts cause an internal compiler error. Use pred calls instead.

:- pred heavy_compute(int::in, int::out) is det.
heavy_compute(N, Sum) :- range_sum(1, N, Sum).

% Move the parallel call to a named predicate to work around Mercury 22.01.8
% backend bug with inline & in the same clause as other pars.
:- pred two_heavy(int::out, int::out) is det.
two_heavy(A, B) :-
    ( heavy_compute(500, A) & heavy_compute(600, B) ).

% NOTE: Mercury 22.01.8 has a backend bug: if-then-else in the SAME clause body
% as a `&` conjunction causes a compiler crash when the condition uses `&` outputs.
% Workaround: pass `&` outputs into named predicates before any if-then-else.

:- pred check_eq(string::in, int::in, int::in, io::di, io::uo) is det.
check_eq(Name, Got, Expected, !IO) :-
    ( Got = Expected ->
        io.format("PASS: %s\n", [s(Name)], !IO)
    ;
        io.format("FAIL: %s (got %d, expected %d)\n",
                  [s(Name), i(Got), i(Expected)], !IO)
    ).

% NOTE: Mercury 22.01.8 backend bug: when multiple predicates containing `&`
% are called in main, ordering matters — some orders crash the compiler.
% Workaround: call predicates that use `&` in the order they are defined.
% two_heavy must be called before par_square2 in the same clause.

main(!IO) :-
    % par_sum correctness.
    range_sum(1, 1000, Seq),
    par_sum(1, 1000, 100, Par),
    check_eq("par_sum 1..1000", Par, Seq, !IO),
    check_eq("par_sum exact value", Par, 500500, !IO),
    par_sum(1, 50, 100, SmallPar),
    range_sum(1, 50, SmallSeq),
    check_eq("par_sum below threshold", SmallPar, SmallSeq, !IO),
    % two_heavy BEFORE par_square2 (ordering workaround).
    two_heavy(A, B),
    range_sum(1, 500, ExpA),
    range_sum(1, 600, ExpB),
    check_eq("parallel A = sum(1..500)", A, ExpA, !IO),
    check_eq("parallel B = sum(1..600)", B, ExpB, !IO),
    % par_square2.
    par_square2(3, 5, Sq3, Sq5),
    check_eq("par_square2: 3^2", Sq3, 9, !IO),
    check_eq("par_square2: 5^2", Sq5, 25, !IO),
    io.write_string("(See README for timing comparison.)\n", !IO).
