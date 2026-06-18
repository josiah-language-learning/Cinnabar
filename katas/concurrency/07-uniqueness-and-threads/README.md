# 07 — Uniqueness and threads

**Concept:** unique modes across thread boundaries; `version_array` as the safe shared
read-only structure; why the uniqueness system prevents data races by construction

**Not in the Mercury tutorial.**

---

## The uniqueness problem with threads

Mercury's uniqueness system prevents aliasing: a unique value can only have one
reference at a time. `thread.spawn` passes a closure to the new thread — if that
closure captures a unique value, both the spawning thread and the new thread would
hold a reference to it simultaneously.

The compiler enforces this: you cannot capture a `unique` or `di` value in a spawn
closure. Attempting to do so is a mode error:

```mercury
:- pred bad_example(array(int)::array_di, io::di, io::uo) is det.
bad_example(Arr, !IO) :-
    thread.spawn((pred(IO0::di, IO1::uo) is cc_multi :-
        % ERROR: Arr is di (destructive input) — cannot share with spawned thread
        _ = array.lookup(Arr, 0),
        IO1 = IO0),
        !IO).
```

The type error is a compile-time guarantee: *Mercury cannot have data races on
unique values*.

---

## `version_array`: safe shared reads

`version_array` is a persistent (functional) array. It supports `O(1)` lookup *for the
current version*; older versions incur a small penalty. Because it is not unique, it can
be shared freely across threads:

```mercury
:- pred read_two(version_array(int)::in, int::out, int::out) is det.
read_two(VA, A, B) :-
    A = version_array.lookup(VA, 0),
    B = version_array.lookup(VA, 1).
```

No mutex needed — the version array is immutable from the reader's perspective. A new
version is created on update; the old version remains valid for other readers.

---

## The write side: still needs synchronisation

`version_array.set` returns a new version. If two threads each update the same version
array:

```
Thread A: VA1 = version_array.set(VA0, 0, 42)
Thread B: VA2 = version_array.set(VA0, 1, 99)
```

`VA1` and `VA2` are both valid, but they diverge — `VA1` has the new value at index 0,
`VA2` has the new value at index 1, and neither has both. Without a mutex around the
read-modify-write cycle, updates are lost.

For concurrent writes, use `mvar` to hold the shared version array and a semaphore
mutex to protect the update cycle.

---

## What you will build

### `read_two(version_array(int), int, int)` — `det`

Read indices 0 and 1 from a `version_array`. No mutex needed — show why.

### `safe_inc(counter, mutex, !IO)` — `det`

Use `mvar` + semaphore to atomically increment a counter backed by an `int mvar`.
Pattern: `wait` → `take` → increment → `put` → `signal`.

### `spawn_incs(N, K, counter, mutex, !IO)` — `cc_multi`

Spawn N threads each calling `safe_inc` K times. Final counter value must be N×K.

### `versioned_counter_demo(!IO)` — `det`

Demonstrate what goes wrong if you update a `version_array` without synchronisation:
start with `VA = version_array([0, 0])`, fork two updaters, show that one update is lost.
Then show the fixed version using a mutex.

---

## Unique vs. non-unique: the key distinction

| Type | Unique? | Shareable across threads? | Safe for concurrent reads? |
|------|---------|--------------------------|---------------------------|
| `array(T)` | yes (`array_di`) | no — compiler error | n/a |
| `version_array(T)` | no (`in`) | yes | yes |
| `mvar(T)` | no (`in`) | yes | no — use mutex |

---

## Checkpoint

- `read_two` compiles with `version_array(int)::in`; attempting it with `array(int)::array_di` gives a mode error
- `spawn_incs(5, 100, ...)` gives a final counter of 500
- You can state: why does the uniqueness system prevent data races on `array(T)`?
- You can state: when is a mutex still needed even with `version_array`?
