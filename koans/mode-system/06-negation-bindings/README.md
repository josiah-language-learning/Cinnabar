# Koan: bindings inside `\+` do not escape

**Broken concept:** using `\+` expecting a variable bound inside the negation to
be available afterwards — the mode checker catches it because `\+` creates an
opaque scope for bindings

## Prerequisites

- `katas/determinism/01-six-categories` — `semidet`, negation as failure
- `katas/mode-system/01-insts-and-modes` — in/out modes, what it means for a
  variable to be free vs ground

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg negation_koan
```

The error points to `T` being `free` where `ground` is expected — `T` is the
`out` argument of `find_important` but is never bound.

---

## What to observe

`\+ Goal` is defined as `( Goal -> fail ; true )`. Goal executes in a private
scope: any bindings it produces are discarded before `\+` succeeds or fails.
This is not a Mercury quirk — it is the standard semantics of negation as
failure from Prolog, enforced here at the mode level.

`list.member(T, Tasks)` binds `T` inside the negation. After `\+`, `T` is still
`free` in the outer clause. The predicate declares `task::out` for `T`, which
requires it to be `ground` at the end of the clause — contradiction.

The mental model that fails here: "negate the bad case and the good binding
flows back." Negation is not a filter that selects the non-matching element.
It is a check that succeeds or fails based on whether Goal has any solutions,
discarding everything Goal would have produced.

---

## Your task

Rewrite `find_important` without `\+`. Use generate-and-test: first bind `T`
with `list.member`, then check the property you care about with a goal that
can fail. `\=` or a comparison is the right tool for the test half.
