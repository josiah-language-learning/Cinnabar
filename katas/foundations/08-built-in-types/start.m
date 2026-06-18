:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module char.
:- import_module int.
:- import_module list.
:- import_module string.

% rem_demo: show both rem and mod for A and B.
:- func rem_demo(int, int) = string.
rem_demo(_A, _B) = "".   % stub: use string.format with both rem and mod

% circular_index: wrap Index into range [0, Size) using mod.
:- func circular_index(int, int) = int.
circular_index(_Index, _Size) = 0.   % stub: use mod

% count_bits: count the number of set bits in N (non-negative).
:- func count_bits(int) = int.
count_bits(_N) = 0.   % stub: use /\ 1 and unchecked_right_shift

% An item for the io.format tag exercise.
:- type item ---> item(name :: string, price :: float, qty :: int, grade :: char).

% format_item: print an item using all four io.format tag types (s, f, i, c).
:- pred format_item(item::in, io::di, io::uo) is det.
format_item(_Item, !IO).   % stub: io.format with [s(...), f(...), i(...), c(...)]

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % Integer division uses // not /.
    check("7 // 2 = 3",  ( 7 // 2 = 3 -> yes ; no ), !IO),
    check("7 // 2 \\= 4", ( 7 // 2 \= 4 -> yes ; no ), !IO),
    % rem has sign of dividend; mod has sign of divisor.
    check("-7 rem 3 = -1",  ( -7 rem 3 = -1 -> yes ; no ), !IO),
    check("-7 mod 3 = 2",   ( -7 mod 3 = 2  -> yes ; no ), !IO),
    check("7 rem -3 = 1",   ( 7 rem -3 = 1  -> yes ; no ), !IO),
    check("7 mod -3 = -2",  ( 7 mod -3 = -2 -> yes ; no ), !IO),
    % Circular index.
    check("circular_index 0 3 = 0", ( circular_index(0, 3) = 0 -> yes ; no ), !IO),
    check("circular_index 5 3 = 2", ( circular_index(5, 3) = 2 -> yes ; no ), !IO),
    check("circular_index 3 3 = 0", ( circular_index(3, 3) = 0 -> yes ; no ), !IO),
    % Bit counting.
    check("count_bits 0 = 0",   ( count_bits(0) = 0   -> yes ; no ), !IO),
    check("count_bits 1 = 1",   ( count_bits(1) = 1   -> yes ; no ), !IO),
    check("count_bits 7 = 3",   ( count_bits(7) = 3   -> yes ; no ), !IO),
    check("count_bits 255 = 8", ( count_bits(255) = 8 -> yes ; no ), !IO),
    % io.format exercise (visual check).
    io.write_string("\nio.format with all four tag types:\n", !IO),
    format_item(item("widget", 9.99, 42, 'A'), !IO).
