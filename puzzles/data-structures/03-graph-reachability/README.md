# Puzzle: graph reachability with tabling

**Primary skills:** `set(T)`, recursion, `pragma memo` / `pragma loop_check` for cycle detection

**Why Mercury:** naive recursive graph traversal loops on cycles. `pragma loop_check` is
the correct Mercury tool for breaking cycles in recursive queries — more elegant than
maintaining a "visited" set manually.

## Prerequisites

- `katas/foundations/05-map` — `map(K, V)`, `set(T)`
- `katas/tooling/04-tabling` — `pragma loop_check`, `pragma memo`, tabling semantics

---

## The problem

Find all nodes reachable from a given start node in a directed graph (which may have cycles).

Input: a graph as `map(node, list(node))` (adjacency list), a start node
Output: `set(node)` of all reachable nodes (including the start)

---

## Representation

```mercury
:- type node == string.
:- type graph == map(node, list(node)).
```

---

## Approach 1: manual visited set

The straightforward approach threads a `set(node)` through the recursion:

```mercury
:- pred reachable(graph::in, node::in, set(node)::in, set(node)::out) is det.
reachable(Graph, Start, Visited0, Visited) :-
    ( set.member(Start, Visited0) ->
        Visited = Visited0
    ;
        Visited1 = set.insert(Visited0, Start),
        ( map.search(Graph, Start, Neighbors) ->
            list.foldl(reachable(Graph), Neighbors, Visited1, Visited)
        ;
            Visited = Visited1
        )
    ).
```

This is correct but verbose — you are manually implementing what `loop_check` does.

---

## Approach 2: `pragma loop_check`

A cleaner version: write `reachable` as a `nondet` predicate that generates reachable nodes,
and use `pragma loop_check` to handle cycles:

```mercury
:- pred reachable_node(graph::in, node::in, node::out) is nondet.
:- pragma loop_check(reachable_node/3).

reachable_node(_, Start, Start).
reachable_node(Graph, Start, Node) :-
    map.search(Graph, Start, Neighbors),
    list.member(Next, Neighbors),
    reachable_node(Graph, Next, Node).
```

Then:
```mercury
solutions(reachable_node(Graph, Start), ReachableList),
set.from_list(ReachableList, Reachable).
```

`pragma loop_check` detects when `reachable_node(Graph, X, _)` is called while already
being evaluated for the same arguments — cutting the cycle rather than looping.

---

## Sample graph

```mercury
example_graph = map.from_assoc_list([
    "a" - ["b", "c"],
    "b" - ["d"],
    "c" - ["b", "e"],
    "d" - ["a"],    % cycle: a → b → d → a
    "e" - []
]).
```

Reachable from "a": {"a", "b", "c", "d", "e"}

---

## What to observe

Without `pragma loop_check` (or a manual visited set), the program loops on the `d → a`
cycle. With it, the cycle is detected and the looping call fails immediately.

Compare: how does the performance of approach 2 compare to approach 1 for large graphs?
(Tabling has overhead; for sparse graphs, the manual set may be faster.)
