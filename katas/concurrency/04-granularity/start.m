:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module string.
:- import_module time.

% SPARK OVERHEAD:
% The `&` operator creates a "spark" — a lightweight work item that may be
% stolen by an idle CPU. Creating a spark has overhead (~microseconds).
% For small work units, spark overhead exceeds the parallel benefit.
%
% THRESHOLD PATTERN: only parallelize when the work is large enough.
%   ( N > Threshold -> (left & right) ; (left, right) )

% Exercise 1: parallel sum with configurable chunk size.
% Sums integers in [Lo, Hi] inclusive.
:- func sum_range(int, int) = int.
sum_range(Lo, Hi) = S :-
    ( Lo > Hi ->
        S = 0
    ;
        S = Lo + sum_range(Lo + 1, Hi)
    ).

% Parallel sum: split at midpoint and compute halves in parallel.
% Only parallelize if the range is larger than Threshold.
:- func par_sum(int, int, int) = int.
par_sum(Lo, Hi, _Threshold) = sum_range(Lo, Hi).
% stub: split at Mid = (Lo + Hi) / 2; if (Hi - Lo) > Threshold then
%   SumL & SumR in parallel, else sequential; return SumL + SumR.

% Exercise 2: parallel map — apply F to each element of a list in parallel.
% Only parallelize if list length exceeds Threshold.
:- func par_map(func(T) = U, list(T), int) = list(U).
par_map(F, List, _Threshold) = list.map(F, List).
% stub: split list in half; parallel map each half if length > Threshold.

% Exercise 3: measure — compare sequential vs parallel sum.
% Returns (sequential_result, parallel_result).
:- pred measure_sum(int::in, int::in, int::out, int::out) is det.
measure_sum(Lo, Hi, Seq, Par) :-
    Seq = sum_range(Lo, Hi),
    Par = par_sum(Lo, Hi, 1000).   % threshold: parallelize above 1000 elements

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % Correctness: par_sum should give same result as sum_range.
    measure_sum(1, 1000, Seq1, Par1),
    check("par_sum 1..1000: matches sequential",
        ( Par1 = Seq1 -> yes ; no ), !IO),
    measure_sum(1, 100, Seq2, Par2),
    check("par_sum 1..100 (below threshold): matches sequential",
        ( Par2 = Seq2 -> yes ; no ), !IO),
    % Known sum: 1..N = N*(N+1)/2.
    Sum100 = 100 * 101 // 2,
    check("sum_range 1..100 = 5050",
        ( sum_range(1, 100) = Sum100 -> yes ; no ), !IO),
    Sum1000 = 1000 * 1001 // 2,
    check("par_sum 1..1000 = 500500",
        ( Par1 = Sum1000 -> yes ; no ), !IO),
    % par_map: apply (X * X) to list.
    Squares = par_map(func(X) = X * X, [1, 2, 3, 4, 5], 3),
    check("par_map squares [1..5] = [1,4,9,16,25]",
        ( Squares = [1, 4, 9, 16, 25] -> yes ; no ), !IO),
    io.write_string("(For timing comparison, see README)\n", !IO).
