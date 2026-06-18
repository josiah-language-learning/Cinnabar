:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module float.
:- import_module int.
:- import_module list.
:- import_module string.

:- type tree(T)
    --->    leaf
    ;       node(tree(T), T, tree(T)).

% Insert V into a BST.  Uses compare/3 (built-in for all Mercury types).
:- pred insert(T::in, tree(T)::in, tree(T)::out) is det.
insert(_V, _Tree, leaf).   % stub: build a node

% Succeed if V is in the tree.
:- pred member(T::in, tree(T)::in) is semidet.
member(_, leaf) :- fail.   % stub

% In-order traversal — produces a sorted list if the tree is a valid BST.
:- pred to_sorted_list(tree(T)::in, list(T)::out) is det.
to_sorted_list(_, []).   % stub: in-order left/value/right

% Apply F to every value, preserving tree shape.
:- func tree_map(func(T) = U, tree(T)) = tree(U).
tree_map(_, leaf) = leaf.
tree_map(_F, node(_L, _V, _R)) = leaf.   % stub: recurse on both subtrees

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

:- func from_list(list(T)) = tree(T).
from_list([]) = leaf.
from_list([H | T]) = T1 :- insert(H, from_list(T), T1).

main(!IO) :-
    T0 = from_list([5, 3, 7, 1, 4]),
    to_sorted_list(T0, Sorted),
    check("to_sorted_list: [5,3,7,1,4] -> [1,3,4,5,7]",
        ( Sorted = [1, 3, 4, 5, 7] -> yes ; no ), !IO),
    check("member: 3 is in tree",
        ( member(3, T0) -> yes ; no ), !IO),
    check("member: 99 is not in tree",
        ( \+ member(99, T0) -> yes ; no ), !IO),
    check("member: 1 is in tree",
        ( member(1, T0) -> yes ; no ), !IO),
    insert(6, T0, T1),
    to_sorted_list(T1, Sorted1),
    check("insert 6: [1,3,4,5,6,7]",
        ( Sorted1 = [1, 3, 4, 5, 6, 7] -> yes ; no ), !IO),
    % tree_map: int tree -> float tree.
    Tf = tree_map(func(X) = float(X), T0),
    to_sorted_list(Tf, SortedF),
    check("tree_map to float: 5 values",
        ( list.length(SortedF) = 5 -> yes ; no ), !IO).
