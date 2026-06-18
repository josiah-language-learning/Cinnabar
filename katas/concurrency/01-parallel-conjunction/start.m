:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module string.

% range_sum_seq: sum integers from Lo to Hi (inclusive) sequentially.
:- func range_sum_seq(int, int) = int.
range_sum_seq(Lo, Hi) =
    ( Lo > Hi -> 0 ; Lo + range_sum_seq(Lo + 1, Hi) ).

% range_sum_par: same computation using parallel conjunction (&).
% Split at midpoint and sum both halves in parallel.
:- pred range_sum_par(int::in, int::in, int::out) is det.
range_sum_par(Lo, Hi, Sum) :-
    ( Lo > Hi ->
        Sum = 0
    ; Lo = Hi ->
        Sum = Lo
    ;
        Mid = (Lo + Hi) / 2,
        % & runs both goals in parallel (requires .par grade)
        ( range_sum_par(Lo, Mid, Left)
        & range_sum_par(Mid + 1, Hi, Right)
        ),
        Sum = Left + Right
    ).

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    Seq = range_sum_seq(1, 100),
    range_sum_par(1, 100, Par),
    check("seq 1..100 = 5050", ( Seq = 5050 -> yes ; no ), !IO),
    check("par matches seq",   ( Par = Seq  -> yes ; no ), !IO),
    range_sum_par(1, 1000, Big),
    check("par 1..1000 = 500500", ( Big = 500500 -> yes ; no ), !IO).
