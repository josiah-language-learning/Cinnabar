:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module array.
:- import_module bag.
:- import_module bimap.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module map.
:- import_module string.
:- import_module version_array.

% ---- Exercise 1: bag (multiset) ----------------------------------------

% Count occurrences of each word using a bag.
% Hint: bag.init, bag.insert, bag.count_value.
:- pred word_counts(list(string)::in, bag(string)::out) is det.
word_counts(_Words, Bag) :-
    bag.init(Bag).   % stub: fold over Words, inserting each into Bag

% Return the count of a single word.
:- pred count_word(bag(string)::in, string::in, int::out) is det.
count_word(_Bag, _Word, 0).   % stub: bag.count_value

% ---- Exercise 2: bimap (bidirectional map) --------------------------------

% Build a symbol table mapping names to int ids and back.
% Hint: bimap.set, bimap.lookup, bimap.reverse_lookup.
:- func build_symtable = bimap(string, int).
build_symtable = bimap.init.   % stub: insert "alpha"->1, "beta"->2, "gamma"->3

% Look up a name → id.
:- func name_to_id(bimap(string, int), string) = int.
name_to_id(_BM, _Name) = -1.   % stub: bimap.lookup

% Look up an id → name (fails if id not in table).
:- pred id_to_name(bimap(string, int)::in, int::in, string::out) is semidet.
id_to_name(_BM, _Id, "").   % stub: bimap.reverse_lookup (semidet on failure)

% ---- Exercise 3: version_array vs array -----------------------------------

% Build a version_array of size N filled with 0s, then set index 2 to 99.
% version_array does NOT require unique modes — you can share the old version.
:- func build_version_array(int) = version_array(int).
build_version_array(_N) = version_array.empty.   % stub

% Return element at index I.
:- func va_lookup(version_array(int), int) = int.
va_lookup(_VA, _I) = 0.   % stub: version_array.lookup

% Build an array(int) of size N filled with 0s, set index 2 to 99, return it.
% NOTE: array requires di/uo (unique) modes — no aliasing allowed.
:- pred build_array(int::in, array(int)::out) is det.
build_array(N, A) :-
    array.init(N, 0, A).   % stub: also set A[2] := 99 via array.set

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % Exercise 1: bag.
    Words = ["apple", "banana", "apple", "cherry", "banana", "apple"],
    word_counts(Words, WB),
    count_word(WB, "apple", AC),
    count_word(WB, "banana", BC),
    check("bag: apple count = 3", ( AC = 3 -> yes ; no ), !IO),
    check("bag: banana count = 2", ( BC = 2 -> yes ; no ), !IO),
    % Exercise 2: bimap.
    BM = build_symtable,
    check("bimap: alpha -> 1", ( name_to_id(BM, "alpha") = 1 -> yes ; no ), !IO),
    check("bimap: 2 -> beta",
        ( id_to_name(BM, 2, N2), N2 = "beta" -> yes ; no ), !IO),
    % Exercise 3: version_array.
    VA = build_version_array(5),
    check("version_array: lookup [2] = 99",
        ( va_lookup(VA, 2) = 99 -> yes ; no ), !IO),
    check("version_array: lookup [0] = 0",
        ( va_lookup(VA, 0) = 0 -> yes ; no ), !IO),
    % Exercise 3: array.
    build_array(5, A),
    check("array: lookup [2] = 99",
        ( array.lookup(A, 2) = 99 -> yes ; no ), !IO),
    check("array: lookup [0] = 0",
        ( array.lookup(A, 0) = 0 -> yes ; no ), !IO).
