:- module prop_ops_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module solutions.
:- import_module string.

% BUG 1: int.between/3 does not exist in Mercury 22.
% Use int.nondet_int_in_range/3 instead.
:- pred gen_small_int(int::out) is nondet.
gen_small_int(N) :-
    int.between(0, 10, N).

% BUG 2: list.length/1 in an equality expression causes type ambiguity.
% list.length exists as both a function (returning int) and a predicate;
% the type checker cannot determine which form is intended.
:- pred prop_length_eq(list(int)::in) is semidet.
prop_length_eq(Xs) :-
    list.length(Xs) = list.length(list.reverse(Xs)).

main(!IO) :-
    solutions(gen_small_int, Ns),
    list.length(Ns, Len),
    io.format("generated %d integers\n", [i(Len)], !IO),
    ( prop_length_eq([1, 2, 3]) ->
        io.write_string("length property holds\n", !IO)
    ;
        io.write_string("FAIL\n", !IO)
    ).
