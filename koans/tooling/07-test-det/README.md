# Koan: test predicate with semidet unification

**Broken concept:** a test predicate declared `det` whose body uses direct
unification (`Got = 6`) as the assertion — unification can fail, making the
body `semidet` and the `det` declaration wrong

## Prerequisites

- `katas/tooling/05-testing` — Mercury test convention, `error/1`, `require/2`
- `katas/determinism/01-six-categories` — det vs semidet

---

Mercury's test convention: a test predicate is `det`. It either succeeds
silently or calls `error/1` (which throws an exception). It must never *fail*
as its way of signaling a test failure — a silent failure would go unnoticed
if the caller uses it in an if-then-else, and is invisible to test harnesses.

Direct unification (`Got = 6`) is `semidet` — it fails if the values don't
match. Using it directly as the final goal in a `det` predicate violates the
`det` declaration.

---

## Try it

```
mmc --make test_det_koan
```

The compiler reports that `test_sum` is declared `det` but inferred `semidet`,
because "unification of `Got' and `6' can fail."

---

## What to observe

The unification `Got = 6` is semidet: it succeeds when `Got = 6` and fails
otherwise. A failing test predicate does not report a useful error — it
just becomes false. The convention is to wrap assertions in if-then-else
with `error/1` in the else branch.

---

## Your task

Rewrite `test_sum` so it is `det`. On mismatch, it should call `error/1`
with a descriptive message including the actual value. Use `import_module require`
to bring `error/1` into scope.
