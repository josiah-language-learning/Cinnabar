# Graph reachability solution notes

## `pragma loop_check` vs manual visited set

Both approaches handle cycles correctly. The tradeoffs:

**Manual visited set:**
- Works in all grades (no tabling requirement)
- Thread-safe, explicit
- Requires threading the set through every recursive call

**`pragma loop_check`:**
- Cleaner predicate structure
- Requires C grade (tabling not available in all backends)
- The tabling overhead per call is non-trivial — for small graphs, manual set is faster

## Why `solutions` + `set.from_list` works

`reachable_node` with `loop_check` is `nondet` — it generates reachable nodes, failing
on cycles rather than looping. `solutions/2` collects all generated nodes. `set.from_list`
deduplicates them (the same node may be reachable via multiple paths).

## The general pattern for recursive graph queries

Whenever you have a transitive closure query that could loop on cycles:
1. Manual: thread a `set` of visited nodes through the recursion
2. Tabling: use `pragma loop_check` or `pragma memo` to let the runtime handle it

Option 2 is only better when the query is complex enough that manual state threading
would be very messy.
