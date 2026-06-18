# Koan set: recognising determinism errors

**Broken concept:** five common determinism error classes — reading the error message,
diagnosing the cause, and applying the right fix

## Prerequisites

- `katas/determinism/01-six-categories` — the six determinism categories
- `katas/determinism/02-committed-choice` — `cc_multi`, `cc_nondet`
- `katas/concurrency/05-deadlock` — `thread.spawn` and `cc_multi` propagation

---

This koan set has five broken files. Compile each one, read the error, understand
the cause, and fix it. Each file has exactly one class of determinism error.

---

## `multi_guard.m` — declared `det`, inferred `nondet`

Two clauses with overlapping guards. For a value that satisfies both guards, both
clauses can match — making the predicate `nondet`, not `det`.

```
mmc --make --grade asm_fast.par.gc.stseg multi_guard
```

**Fix:** replace overlapping clauses with a single if-then-else chain. The
`( A -> B ; C -> D ; E )` pattern covers every case exactly once.

---

## `nondet_direct.m` — `nondet` called directly in `det` context

A `nondet` predicate called in a `det` body. `det` has nowhere to put the extra
solutions — the compiler rejects it.

```
mmc --make --grade asm_fast.par.gc.stseg nondet_direct
```

**Fix:** wrap the nondet call in `solutions/2` to collect all results into a `list(T)`,
then work with the list in the det context.

---

## `semidet_io.m` — semidet predicate with I/O state

A predicate declared `semidet` that threads `io::di, io::uo`. If the predicate fails,
the `io` token disappears — the I/O state is never consumed. Mercury catches this: any
predicate with I/O state must be at least `det`.

```
mmc --make --grade asm_fast.par.gc.stseg semidet_io
```

**Fix:** change the declaration to `det` and use if-then-else to handle the
non-printing case with `true`.

---

## `par_semidet.m` — `semidet` goals in parallel conjunction

`&` requires both sub-goals to be `det`. A `semidet` goal may fail — Mercury cannot
parallelize goals that can fail because there is no recovery path in the other branch.

```
mmc --make --grade asm_fast.par.gc.stseg par_semidet
```

Error: "parallel conjunct may fail. The current implementation supports only
single-solution non-failing parallel conjunctions."

**Fix:** make both sub-goals `det`. Move any conditional logic outside the `&`, or
restructure so the parallel goals always succeed.

---

## `cc_unwrapped.m` — `cc_multi` called from `det`

`thread.spawn` is `cc_multi`. Calling it from a `det` predicate causes the outer
predicate to be inferred `multi` (or `cc_multi`), which contradicts the `det`
declaration.

```
mmc --make --grade asm_fast.par.gc.stseg cc_unwrapped
```

Error: "call to predicate `thread.spawn'/3 with determinism `cc_multi' occurs in a
context which requires all solutions."

**Fix:** change the calling predicate's declaration to `cc_multi`. The `cc_multi`
annotation propagates up the call chain — `main` must also become `cc_multi`.

---

## The underlying rule

Every call propagates its determinism upward. A caller must have a determinism that
is *compatible* with the callee's:
- `det` can call `det` and `semidet` (via if-then-else)
- `det` cannot directly call `nondet`, `multi`, or `cc_multi`
- `cc_multi` can call `cc_multi` and `det`
- `&` sub-goals must each be `det`
- I/O-threading predicates must be at least `det`
