# Kata: `array` threading vs `version_array`

## Concept

Mercury offers two array types with different uniqueness models:

**`array(T)`** — unique, destructive update:
- Modes: `array_di` (destroy on read/write), `array_uo` (produce)
- `array.set` consumes the input array — you cannot read the original after
- O(1) per update; no extra allocation
- Thread the array through every operation: `array.set(I, V, A0, A1)` — `A0` is consumed

**`version_array(T)`** — persistent, copy-on-write:
- Modes: ordinary `in`/`out` — no uniqueness constraint
- After `version_array.set`, the original is still readable
- O(1) amortised update (O(n) if accessed after a newer version)
- Safe to alias: two variables can refer to the same version_array

## Prerequisites

- `katas/mode-system/03-uniqueness-deep` — intro to both types (see also for comparison)
- `koans/foundations/09-array-unique` — `array.set` consumes its input

## Exercises

**Task 1:** Complete `histogram/3` using `array`. Thread the array with `!A` or
explicit `A0, A1` variables. Use `array.lookup` to read the current count and
`array.set` to write the new count. The stub provides `array.init` — add a
`list.foldl` over the items.

**Task 2:** Complete `va_histogram/3` using `version_array`. The API mirrors
`array` but uses ordinary variables (no di/uo). Use `version_array.lookup` and
`version_array.set`.

**Task 3:** Implement `aliasing_demo` to show that `version_array` can be aliased:
create a reference alias (`VA1 = VA0`), update (`version_array.set(0, 99, VA0, VA2)`),
and verify that `VA1` still reads the old value (`10`) while `VA2` reads the new
value (`99`). This is forbidden with a unique `array` — the alias would violate the
uniqueness constraint.

## When to use each

| | `array(T)` | `version_array(T)` |
|---|---|---|
| Update style | Destructive (di/uo threading) | Copy-on-write |
| Keep old version | No | Yes |
| Aliasing | Forbidden | Allowed |
| Update cost | O(1) | O(1) amortised |
| Access old version | Impossible | O(n) if old |

Use `array` when you need maximum performance and will never need old versions.
Use `version_array` when you need persistence, aliasing, or concurrent read access.

## Run the tests

```
./runtests
```

Expected output:
```
PASS: hist[0] = 3
PASS: hist[1] = 2
PASS: hist[2] = 1
PASS: va hist[0] = 3
PASS: va hist[1] = 2
PASS: va hist[2] = 1
aliasing_demo: ...
```
