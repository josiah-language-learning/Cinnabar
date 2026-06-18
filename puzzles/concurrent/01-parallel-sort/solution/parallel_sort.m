:- module parallel_sort.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module string.

%---------------------------------------------------------------------------%
% Det list splitting — list.take/drop are semidet; this custom version
% always succeeds (returns [] if N > length).

:- pred split_at(int::in, list(T)::in, list(T)::out, list(T)::out) is det.
split_at(N, List, Left, Right) :-
    ( N =< 0 ->
        Left = [], Right = List
    ; List = [H | T] ->
        split_at(N - 1, T, L0, Right),
        Left = [H | L0]
    ;
        Left = [], Right = []
    ).

%---------------------------------------------------------------------------%
% Sequential mergesort (baseline)

:- pred mergesort_seq(list(int)::in, list(int)::out) is det.
mergesort_seq(List, Sorted) :-
    ( List = [] ->
        Sorted = []
    ; List = [X] ->
        Sorted = [X]
    ;
        list.length(List, Len),
        Half = Len // 2,
        split_at(Half, List, Left, Right),
        mergesort_seq(Left, SLeft),
        mergesort_seq(Right, SRight),
        merge_sorted(SLeft, SRight, Sorted)
    ).

%---------------------------------------------------------------------------%
% Parallel mergesort (requires .par grade)

:- func threshold = int.
threshold = 1000.

:- pred mergesort_par(list(int)::in, list(int)::out) is det.
mergesort_par(List, Sorted) :-
    ( List = [] ->
        Sorted = []
    ; List = [X] ->
        Sorted = [X]
    ;
        list.length(List, Len),
        ( Len =< threshold ->
            list.sort(List, Sorted)
        ;
            Half = Len // 2,
            split_at(Half, List, Left, Right),
            % Parallel: sort both halves concurrently
            mergesort_par(Left, SLeft)
            &
            mergesort_par(Right, SRight),
            merge_sorted(SLeft, SRight, Sorted)
        )
    ).

%---------------------------------------------------------------------------%
% Merge two sorted lists — if-then-else avoids nondet multiple-clause issue

:- pred merge_sorted(list(int)::in, list(int)::in, list(int)::out) is det.
merge_sorted(Xs, Ys, Merged) :-
    ( Xs = [] ->
        Merged = Ys
    ; Ys = [] ->
        Merged = Xs
    ; Xs = [X | Xs0], Ys = [Y | Ys0] ->
        ( X =< Y ->
            merge_sorted(Xs0, Ys, Rest),
            Merged = [X | Rest]
        ;
            merge_sorted(Xs, Ys0, Rest),
            Merged = [Y | Rest]
        )
    ;
        Merged = Xs  % unreachable: both Xs and Ys are non-empty here
    ).

%---------------------------------------------------------------------------%

:- func make_descending(int) = list(int).
make_descending(N) = ( N =< 0 -> [] ; [N | make_descending(N - 1)] ).

main(!IO) :-
    N = 10000,
    Input = make_descending(N),
    io.write_string("Sorting sequential... ", !IO),
    io.flush_output(!IO),
    mergesort_seq(Input, Sorted1),
    io.write_string("done.\n", !IO),
    io.write_string("Sorting parallel... ", !IO),
    io.flush_output(!IO),
    mergesort_par(Input, Sorted2),
    io.write_string("done.\n", !IO),
    ( Sorted1 = Sorted2 ->
        io.write_string("Results match.\n", !IO)
    ;
        io.write_string("MISMATCH!\n", !IO)
    ),
    list.length(Sorted1, Len),
    io.format("Sorted %d elements.\n", [i(Len)], !IO).
