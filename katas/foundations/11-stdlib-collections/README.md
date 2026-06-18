# 11 — Standard library collections

**Concept:** `bag`, `bimap`, `array` vs `version_array` — the less-visited stdlib
structures

**Not in the Mercury tutorial.**

---

## `bag` — multisets

`bag(T)` is a multiset: it tracks how many times each element appears.

```mercury
:- import_module bag.

Counts = bag.from_list(["a", "b", "a", "c", "a"]),
% bag.count(Counts, "a") = 3
% bag.count(Counts, "b") = 1
```

Use case: counting word occurrences without a `map(string, int)`. `bag` handles the
bookkeeping automatically.

---

## `bimap` — bidirectional maps

`bimap(K, V)` is a bijection: each key maps to exactly one value and each value maps to
exactly one key. Lookup works in both directions.

```mercury
:- import_module bimap.

Table = bimap.from_assoc_list(["alpha" - 1, "beta" - 2, "gamma" - 3]),
bimap.lookup(Table, "alpha", N),    % N = 1 (forward)
bimap.reverse_lookup(Table, 2, S), % S = "beta" (reverse)
```

Use case: two-way symbol tables, enum ↔ name mappings.

**Note:** `bimap` enforces the bijection — inserting a value already mapped to a different
key replaces the old entry on both sides.

---

## `array` vs `version_array`

Both provide O(1) indexed access, but their mode requirements differ fundamentally.

### `array`

`array` operations require **unique** (`di`/`uo`) modes. Only one live reference is
allowed at a time:

```mercury
array.init(5, 0, Arr0),          % Arr0 :: array_uo
array.set(2, 99, Arr0, Arr1),    % Arr0 consumed, Arr1 produced
V = array.lookup(Arr1, 2)        % V = 99
```

Attempting to branch on a unique array in a disjunction is a mode error — each branch
would try to consume the same unique value.

### `version_array`

`version_array` is persistent. It uses O(1) amortized access but allows multiple live
references — lookup takes `in`, not `di`:

```mercury
VA0 = version_array.from_list([10, 20, 30]),
VA1 = version_array.set(VA0, 1, 99),     % VA0 still valid
V0 = version_array.lookup(VA0, 1),       % 20 — original unchanged
V1 = version_array.lookup(VA1, 1)        % 99 — updated
```

Use `version_array` when you need to share an array across predicates or retain old
versions. Use `array` when you are doing a sequential in-place transformation.

---

## What you will build

### Word counter with `bag`

Count word occurrences in a `list(string)`:
```mercury
:- pred word_counts(list(string)::in, bag(string)::out) is det.
```

### Symbol table with `bimap`

Build a `bimap(string, int)` mapping `"alpha" → 1`, `"beta" → 2`, `"gamma" → 3`.
Look up both directions from `main`.

### Array fill

`build_array(N, A)`: initialise an array of `N` elements to 0, then set `A[2] := 99`.
Use `array.init` and `array.set`.

### Version array

`build_version_array(N)`: return a `version_array(int)` of `N` elements where each
element equals its index. Use `version_array.init` and `version_array.set`.

---

## Checkpoint

- `word_counts` correctly counts repeated words using `bag`
- The bimap symbol table supports forward and reverse lookup
- `build_array` compiles — note the unique-mode chain through `!IO` or local vars
- `build_version_array` compiles and retains old versions correctly
- You can state: why does `array` require `di`/`uo` while `version_array` takes `in`?
