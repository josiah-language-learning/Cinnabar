:- module histogram.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module list.
:- import_module map.
:- import_module pair.
:- import_module string.
:- import_module int.

:- pred count_words(list(string)::in, map(string, int)::out) is det.
count_words(Words, Counts) :-
    list.foldl(tally, Words, map.init, Counts).

:- pred tally(string::in,
              map(string, int)::in, map(string, int)::out) is det.
tally(W, !M) :-
    ( map.search(!.M, W, C) ->
        map.set(W, C + 1, !M)
    ;
        map.set(W, 1, !M)
    ).

:- pred print_histogram(map(string, int)::in, io::di, io::uo) is det.
print_histogram(Counts, !IO) :-
    Pairs = map.to_assoc_list(Counts),
    list.sort((pred((_-CA)::in, (_-CB)::in, Order::out) is det :-
        compare(Order, CB, CA)),
        Pairs, Sorted),
    ( Sorted = [_-MaxCount | _] ->
        MaxBarLen = 30,
        MaxLabelLen = list.foldl(
            (func(W-_ , A) = int.max(A, string.length(W))),
            Sorted, 0),
        list.foldl(print_bar(MaxCount, MaxBarLen, MaxLabelLen), Sorted, !IO)
    ;
        io.write_string("(no words)\n", !IO)
    ).

:- pred print_bar(int::in, int::in, int::in, pair(string, int)::in,
                  io::di, io::uo) is det.
print_bar(MaxCount, MaxBarLen, LabelWidth, Word - Count, !IO) :-
    BarLen = MaxBarLen * Count // MaxCount,
    Bar = string.duplicate_char('*', BarLen),
    Label = string.pad_right(Word, ' ', LabelWidth),
    io.format("%s | %s (%d)\n", [s(Label), s(Bar), i(Count)], !IO).

main(!IO) :-
    io.read_file_as_string(io.stdin_stream, Res, !IO),
    (
        Res = ok(Text),
        Words = list.map(string.to_lower, string.words(Text)),
        count_words(Words, Counts),
        print_histogram(Counts, !IO)
    ;
        Res = error(_, Err),
        io.format("Error: %s\n", [s(io.error_message(Err))], !IO)
    ).
