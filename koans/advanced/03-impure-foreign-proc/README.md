# Koan: `foreign_proc` without `promise_pure` is impure by default

**Broken concept:** omitting `promise_pure` from a `foreign_proc` — Mercury
conservatively treats all foreign code as impure, and calling impure predicates
from pure Mercury code is a compiler error

## Prerequisites

- `katas/advanced/01-ffi-depth` — `foreign_proc`, FFI attributes
- `koans/advanced/01-ffi` — `will_not_call_mercury` and attribute semantics

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg purity_koan
```

Two errors, both at `c_square`'s declaration:

```
purity error: predicate is impure.
It must be declared `impure' or promised pure.

foreign clause for predicate `c_square'/2 has purity impure
but that predicate has been declared pure.
```

The error fires at the **predicate**, not at the call site. Mercury checks purity
consistency when it processes the `foreign_proc` clause: the clause is impure
(no `promise_pure`), but the `:- pred` declaration implies pure (the default).
That contradiction is the error.

---

## What to observe

Mercury cannot inspect foreign code. It cannot know whether the C body reads
global state, calls `rand()`, writes to memory, or is a pure computation. So
by default, every `foreign_proc` is **impure**: the compiler treats it as having
arbitrary side effects and refuses to allow it in pure Mercury code.

`promise_pure` is the programmer's assertion that the foreign code is, from
Mercury's perspective, a pure function of its inputs. Once asserted, the
predicate can be called from pure code and is subject to normal Mercury
optimisations (reordering, common subexpression elimination, etc.).

The attribute is a *promise*, not a check. If you add `promise_pure` to a
`foreign_proc` that actually mutates global state, Mercury will happily
reorder or eliminate calls, producing incorrect behaviour with no compiler
warning. The promise is irrevocable.

---

## When `promise_pure` is valid

Use it when the C code is a true mathematical function of its inputs:
no global reads, no memory mutation beyond the declared outputs, no IO.
`N * N`, `strlen`, `abs`, conversion functions — all are valid candidates.

## When `promise_pure` is not valid

Do not use it for `rand()`, file access, reference counting, or anything
that reads or writes state outside the call. For genuinely impure foreign
predicates, either:

- declare the Mercury wrapper `:- impure` and propagate the purity constraint
  up the call chain, or
- thread `!IO` through the call to make the side effect explicit in Mercury's
  type system (the most common approach for IO-performing foreign code)

---

## Your task

Add `promise_pure` to `c_square`'s attribute list. The fix is one word —
the point of the koan is understanding *why* it is required and *when* it
is truthful.
