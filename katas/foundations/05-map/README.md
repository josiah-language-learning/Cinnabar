# 02 — Map: word tally

**Concept:** `map(K, V)` — insert-or-update, `map.search` vs. `map.lookup`, `map.to_assoc_list`, sorting and printing

**What you will build:** a word frequency counter. Read whitespace-separated words from stdin (or a file passed as an argument), tally occurrences into a `map(string, int)`, print sorted by word.

---

## Steps

### 1. Write `tally.m`

Read input — loop on `io.read_line_as_string`, or slurp the whole stream and split with `string.words`.

Fold the word list into a `map(string, int)`. **Do it two ways** and note the difference:

**Way 1 — explicit branch:**
```mercury
( map.search(Map, Word, Count) ->
    map.det_update(Map, Word, Count + 1, Map1)
;
    map.det_insert(Map, Word, 1, Map1)
)
```

**Way 2 — single call:**
```mercury
( map.search(Map, Word, OldCount) ->
    NewCount = OldCount + 1
;
    NewCount = 1
),
map.set(Map, Word, NewCount, Map1)
```

Or more tightly: use `map.search` to get the old count (defaulting to 0 on failure), increment, then `map.set`.

Try both. Notice that `map.set` is insert-or-overwrite — it does not care whether the key is already present.

### 2. Sort and print

```mercury
map.to_assoc_list(Map) = AssocList,
list.sort(AssocList, Sorted),
list.foldl(print_entry, Sorted, !IO)
```

---

## `map` reference

Verify exact signatures in the [Mercury Library Reference](https://mercurylang.org/information/doc-latest/mercury_library/map.html) — these are the shapes, not necessarily the exact argument order:

| Predicate | Determinism | Notes |
|---|---|---|
| `map.init` | `det` | empty map |
| `map.search(Map, Key, Value)` | `semidet` | fails if `Key` absent |
| `map.lookup(Map, Key) = Value` | `det` | aborts if `Key` absent |
| `map.set(!Map, Key, Value)` | `det` | insert-or-overwrite |
| `map.det_insert(!Map, Key, Value)` | `det` | aborts if key *already present* |
| `map.det_update(!Map, Key, Value)` | `det` | aborts if key *absent* |
| `map.to_assoc_list(Map) = AssocList` | `det` | convert to `list(pair(K, V))` |

---

## Checkpoint

- Repeated words tally correctly, output is sorted alphabetically
- You have used both the `search`+branch approach and `set`
- You can say in one sentence why `det_insert` aborting on a duplicate and `det_update` aborting on a miss are *useful* failures — what programming error does each one catch?

## The idiom to carry forward

`map.search`/`map.lookup` vs. `map.det_insert`/`map.det_update` is the same determinism-in-the-name pattern as `semidet` vs. `det` in your own predicates. The name tells you the contract. Reading a `det_insert` call tells you the author believed the key was new at that point — if the belief is wrong, the program fails loudly rather than silently overwriting data.
