# Koan: `array.set` consumes its input — updates must chain

**Broken concept:** reusing an array variable after `array.set` has consumed it

## Prerequisites

- `katas/foundations/11-stdlib-collections` — `array`, unique modes, `di`/`uo`
- `koans/mode-system/04-uniqueness-violation` — unique state cannot be aliased

---

```
mmc array_koan.m
```

The error is a unique-mode error: "the called procedure would clobber its
argument, but variable `Arr0' is still live."

There is also a warning: `Arr1` occurs only once. Together these two signals
point at the same bug — `Arr0` is used where `Arr1` should be, so `Arr1` is
produced but never consumed.

---

## What to observe

`array.set` has mode `(in, in, array_di, array_uo) is det`. The third argument
(`array_di`) is destructively consumed — the array is modified in place and the
original handle is invalidated. The new handle comes out as the fourth argument
(`array_uo`).

This is the same pattern as `!IO`: each operation takes the old state and
produces a new one. Each update must thread through the *output* of the previous
call, forming a linear chain:

```
Arr0 →[set 0]→ Arr1 →[set 1]→ Arr2 →[set 2]→ Result
```

Reusing `Arr0` after it has been consumed violates uniqueness.

---

## Your task

Replace `Arr0` with `Arr1` in the second `array.set` call. Every link in the
chain must use the output of its predecessor.
