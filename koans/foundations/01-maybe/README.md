# Koan: map_maybe expects a func, not a pred

**Broken concept:** passing a `pred` to `map_maybe` instead of a `func`

## Prerequisites

- `katas/foundations/02-maybe` — `map_maybe` and the `func` vs `pred` distinction

---

`map_maybe` has the signature:
```mercury
:- func map_maybe(func(T) = U, maybe(T)) = maybe(U).
```

It expects a *function* (`func(T) = U`), not a *predicate* (`pred(T, U)`). Passing
a `pred` causes a type error.

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg maybe_koan
```

Read the error. It will say something about a type mismatch — the argument type
`pred(int, int)` is not compatible with the expected `func(int) = int`.

---

## Your task

Fix the code so that `map_maybe` is called correctly. You have two options:
1. Convert `double_it` from a `pred` to a `func`
2. Wrap it in an inline lambda of the correct kind

Both work. The solution uses option 1 as the idiomatic choice.
