:- module prop_test.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module maybe.
:- import_module solutions.
:- import_module string.

% ---- runner ----------------------------------------------------------

:- pred check_property(string::in,
    pred(T)::in(pred(out) is nondet),
    pred(T)::in(pred(in) is semidet),
    io::di, io::uo) is det.
check_property(Name, Gen, Prop, !IO) :-
    solutions(Gen, Cases),
    find_counterexample(Prop, Cases, Result),
    (
        Result = no,
        io.format("PASS %s (%d cases)\n",
            [s(Name), i(list.length(Cases))], !IO)
    ;
        Result = yes(Counter),
        io.format("FAIL %s: counterexample = ", [s(Name)], !IO),
        io.write_line(Counter, !IO)
    ).

:- pred find_counterexample(pred(T)::in(pred(in) is semidet),
    list(T)::in, maybe(T)::out) is det.
find_counterexample(_, [], no).
find_counterexample(Prop, [X | Xs], Result) :-
    ( Prop(X) ->
        find_counterexample(Prop, Xs, Result)
    ;
        Result = yes(X)
    ).

% ---- generators ------------------------------------------------------

:- pred gen_small_int(int::out) is nondet.
gen_small_int(N) :- int.nondet_int_in_range(-10, 10, N).

:- pred gen_nat(int::out) is nondet.
gen_nat(N) :- int.nondet_int_in_range(0, 20, N).

:- pred gen_tiny_int(int::out) is nondet.
gen_tiny_int(N) :- int.nondet_int_in_range(-3, 3, N).

:- pred gen_list_aux(int::in, list(int)::out) is nondet.
gen_list_aux(0, []).
gen_list_aux(Len, [H | T]) :-
    Len > 0,
    gen_tiny_int(H),
    gen_list_aux(Len - 1, T).

:- pred gen_small_list(list(int)::out) is nondet.
gen_small_list(Xs) :-
    int.nondet_int_in_range(0, 3, Len),
    gen_list_aux(Len, Xs).

% ---- properties ------------------------------------------------------

:- pred prop_abs_nonneg(int::in) is semidet.
prop_abs_nonneg(N) :- int.abs(N) >= 0.

:- pred prop_double_add(int::in) is semidet.
prop_double_add(N) :- N * 2 = N + N.

:- pred prop_positive(int::in) is semidet.
prop_positive(N) :- N > 0.

:- pred prop_reverse_length(list(int)::in) is semidet.
prop_reverse_length(Xs) :-
    list.length(Xs, Len),
    list.length(list.reverse(Xs), Len).

:- pred prop_no_duplicates(list(int)::in) is semidet.
prop_no_duplicates([]).
prop_no_duplicates([H | T]) :-
    not list.member(H, T),
    prop_no_duplicates(T).

% ---- main ------------------------------------------------------------

main(!IO) :-
    check_property("prop_abs_nonneg",     gen_small_int,  prop_abs_nonneg,     !IO),
    check_property("prop_double_add",     gen_small_int,  prop_double_add,     !IO),
    check_property("prop_positive",       gen_small_int,  prop_positive,       !IO),
    check_property("prop_reverse_length", gen_small_list, prop_reverse_length, !IO),
    check_property("prop_no_duplicates",  gen_small_list, prop_no_duplicates,  !IO).
