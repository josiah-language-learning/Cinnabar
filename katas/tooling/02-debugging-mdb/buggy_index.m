:- module buggy_index.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module string.

% nth_element: return the Nth element of a list (0-based).
% There is an intentional off-by-one bug here.
% Use mdb to find it:
%   1. mmc --make --grade asm_fast.gc.debug buggy_index
%   2. mdb ./buggy_index
%   3. break on nth_element, step through, watch I and List.
:- func nth_element(int, list(string)) = string.
nth_element(_, []) = "out of bounds".
nth_element(I, [H|T]) =
    ( I =< 0 ->      % BUG: should be I = 0, not I =< 0
        H
    ;
        nth_element(I - 1, T)
    ).

main(!IO) :-
    Items = ["zero", "one", "two", "three", "four"],
    io.format("index 0: %s\n", [s(nth_element(0, Items))], !IO),
    io.format("index 1: %s\n", [s(nth_element(1, Items))], !IO),
    io.format("index 2: %s\n", [s(nth_element(2, Items))], !IO),
    % Expected: zero, one, two
    % With the bug, index 0 returns the correct answer but for the wrong reason;
    % negative indices also return "zero".  Step through mdb to see why.
    io.format("index -1 (should be out of bounds): %s\n",
              [s(nth_element(-1, Items))], !IO).
