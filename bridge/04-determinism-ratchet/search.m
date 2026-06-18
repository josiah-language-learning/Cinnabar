:- module search.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module list.
:- import_module solutions.
:- import_module string.

:- type color ---> red ; green ; blue.
:- type coloring --->
    coloring(
        node1 :: color,
        node2 :: color,
        node3 :: color
    ).

% Generates all three colors nondeterministically.
:- pred color_val(color::out) is multi.
color_val(red).
color_val(green).
color_val(blue).

:- func color_name(color) = string.
color_name(red)   = "red".
color_name(green) = "green".
color_name(blue)  = "blue".

% Graph: three nodes arranged in a path 1-2-3.
% Edges: (1,2) and (2,3). Node 1 and node 3 are NOT adjacent.
%
% A valid coloring assigns a color to each node such that
% no two adjacent nodes share a color.
:- pred valid_coloring(coloring::out) is nondet.
valid_coloring(coloring(C1, C2, C3)) :-
    color_val(C1),
    color_val(C2),
    color_val(C3),
    C1 \= C2,
    C2 \= C3.

:- pred print_coloring(coloring::in, io::di, io::uo) is det.
print_coloring(coloring(C1, C2, C3), !IO) :-
    io.format("  1:%-6s 2:%-6s 3:%-6s\n",
        [s(color_name(C1)), s(color_name(C2)), s(color_name(C3))], !IO).

main(!IO) :-
    solutions(valid_coloring, Colorings),
    io.format("All valid colorings (%d):\n", [i(list.length(Colorings))], !IO),
    list.foldl(print_coloring, Colorings, !IO).
