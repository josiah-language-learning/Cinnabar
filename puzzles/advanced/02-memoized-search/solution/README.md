# Memoized search solution notes

## Why `pragma memo` breaks cycles here

When `path(G, "a", "d", _, _)` is called, it is recorded in the memo table as "in
progress." When the cycle causes `path(G, "a", "d", _, _)` to be called again, the
memo table returns only the results computed so far (none yet, since the first call is
still running) — effectively failing. This prevents the infinite loop.

The cost: some paths through cycles may be missed if they require revisiting the start
node. For shortest-path specifically, revisiting a node can only increase cost (assuming
positive edge weights), so missing those paths is correct.

## Dijkstra vs tabling

Dijkstra's algorithm is O((V + E) log V) and always finds the shortest path. The tabling
approach above is correct for small graphs but may be exponential for large ones — it
generates all paths (with cycle breaking) and then picks the shortest.

For production shortest-path: use Dijkstra or A*. The tabling approach is valuable for:
1. Demonstrating that Mercury's tabling subsumes the manual "visited set" pattern
2. Cases where you need all paths, not just the shortest
3. Graphs where the path count is small relative to the state space

## `solutions` and cost extraction

`solutions(path(Graph, Start, Goal), Paths)` gives a list of `pair(int, list(node))`.
The `foldl` extracts the minimum-cost path. This is O(P) in the number of paths — for
small graphs, completely fine.
