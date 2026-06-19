:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module solutions.
:- import_module string.

:- pred gen_small_int(int::out) is nondet.
gen_small_int(N) :-
    int.nondet_int_in_range(0, 10, N).

:- pred prop_length_eq(list(int)::in) is semidet.
prop_length_eq(Xs) :-
    list.length(Xs, Len),
    list.length(list.reverse(Xs), Len).

main(!IO) :-
    solutions(gen_small_int, Ns),
    list.length(Ns, Len),
    io.format("generated %d integers\n", [i(Len)], !IO),
    ( prop_length_eq([1, 2, 3]) ->
        io.write_string("length property holds\n", !IO)
    ;
        io.write_string("FAIL\n", !IO)
    ).
