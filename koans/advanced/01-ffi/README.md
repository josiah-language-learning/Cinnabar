# Koan: `foreign_proc` missing `will_not_call_mercury`

**Broken concept:** omitting `will_not_call_mercury` from a `foreign_proc` that does
not call back into Mercury — causes unnecessary mutex acquisition on every FFI call

## Prerequisites

- `katas/advanced/01-ffi-depth` — `foreign_proc`, FFI attributes, purity annotations

---

This is a performance bug, not a correctness bug. The code compiles and runs correctly.
But without `will_not_call_mercury`, Mercury's runtime acquires a lock on every call to
the foreign procedure, even though it is not needed.

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg ffi_koan
```

Builds and runs. Benchmark the call in a loop — it will be slower than the fixed version
because of the per-call mutex acquisition.

---

## The attributes

`foreign_proc` accepts several attributes that affect the runtime's behavior:

| Attribute | Meaning | Required when |
|-----------|---------|---------------|
| `will_not_call_mercury` | C code does not call back into Mercury | Whenever true — avoids mutex |
| `may_call_mercury` | C code may call back into Mercury | Default if omitted |
| `thread_safe` | C code is thread-safe | Needed for parallel grades |
| `promise_pure` | The Mercury-level view of this predicate is pure | Wrapping impure C in pure Mercury |
| `tabled_for_io` | IO effects are tracked in the tabling system | Needed with `.tr` grade |

---

## Your task

Add `will_not_call_mercury` to the `foreign_proc` attributes list. The fixed version
runs measurably faster in tight loops.
