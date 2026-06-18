:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module list.
:- import_module map.
:- import_module pair.
:- import_module string.

% Fold a list of words into a frequency map.
:- func tally_words(list(string)) = map(string, int).
tally_words(_) = map.init.   % stub

% Pretty-print one entry from the tally map.
:- pred print_entry(pair(string, int)::in, io::di, io::uo) is det.
print_entry(Word - Count, !IO) :-
    io.format("%s: %d\n", [s(Word), i(Count)], !IO).

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    check("single word tallied",
        ( map.search(tally_words(["hello"]), "hello", 1) -> yes ; no ), !IO),
    check("repeated word counted",
        ( map.search(tally_words(["a", "b", "a"]), "a", 2) -> yes ; no ), !IO),
    check("distinct words separate",
        ( map.search(tally_words(["a", "b", "a"]), "b", 1) -> yes ; no ), !IO),
    check("absent key not found",
        ( \+ map.search(tally_words(["hello"]), "world", _) -> yes ; no ), !IO),
    check("empty input empty map",
        ( tally_words([]) = map.init -> yes ; no ), !IO),
    Words = string.words("the cat sat on the mat the cat"),
    Tally = tally_words(Words),
    check("\"the\" appears 3 times",
        ( map.search(Tally, "the", 3) -> yes ; no ), !IO),
    check("\"cat\" appears 2 times",
        ( map.search(Tally, "cat", 2) -> yes ; no ), !IO),
    % Print sorted output (visual check).
    AssocList = map.to_assoc_list(Tally),
    list.sort(AssocList, Sorted),
    io.write_string("\nWord frequencies (sorted):\n", !IO),
    list.foldl(print_entry, Sorted, !IO).
