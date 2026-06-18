# Koan: integer division with `/` instead of `//`

**Broken concept:** using the `/` operator on `int` values

## Prerequisites

- `katas/foundations/08-built-in-types` — `//` vs `/`, `rem` vs `mod`, `io.format` poly-type tags

---

In Mercury, `/` is defined for `float` but **not** for `int`. Integer division uses `//`.
Using `/` on two integers is a type error.

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg types_koan
```

The compiler says something like: `type error in argument 1 of operator '/'/2: variable
has type 'int', expected type 'float'`.

The error message is initially confusing because `/` looks like the natural division
operator. The fix is to replace `/` with `//`.

---

## Also observe

The koan also demonstrates `rem` vs `mod` on a negative — this is a logic error
(wrong sign on the result), not a compile error. Check the output of both expressions
when `A = -7, B = 3` and understand the difference.

---

## Your task

Fix the type error by using `//` for integer division. Then read the `rem` vs `mod`
output and understand which one you would use for a positive-modulo requirement.
