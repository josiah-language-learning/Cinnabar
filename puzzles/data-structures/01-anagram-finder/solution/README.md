# Anagram finder solution notes

## The canonical-key pattern

Sort each word's letters → use as map key → accumulate same-key words.

This pattern appears constantly in Mercury: derive a normalized form, group by it.
The `map` module makes this O(N log N) in the word count.

## `map.search` vs `map.lookup`

`map.search(Map, Key, Value)` is `semidet` — it fails if the key is absent.
`map.lookup(Map, Key, Value)` is `det` — it throws if the key is absent.

Use `search` when absence is expected (as here). Use `lookup` when absence is a bug.

## `map.set` vs `map.det_insert`

`map.set` unconditionally sets the key (insert or replace).
`map.det_insert` throws if the key already exists.

Since we may encounter the same canonical form twice, `map.set` is correct here.
