# Solution: use consistent phantom units

## The error

```
phantom_koan.m: type error: variable `M' has type `length(phantom_koan.miles)',
    expected type was `length(phantom_koan.km)'.
```

`add_lengths(K, M, ...)` unifies the first argument with `length(km)`. The second
argument must have the same `U` — but `M :: length(miles)`. Mercury catches this
mismatch at compile time: no runtime check, no conversion, no cast.

## The fix

Use the same unit for both arguments:

```mercury
K = length(5.0) : length(km),
M = length(3.0) : length(km),   % consistent unit
add_lengths(K, M, length(Sum)),
```

## Why phantom types

`length(km)` and `length(miles)` have identical runtime representations — both are
`length(float)`. A predicate that accepts `float` directly cannot distinguish them.
The phantom parameter `U` is erased before code generation but enforced before erasure.

This is the full value: **zero runtime cost, compile-time unit safety**. Passing a
`miles` value where `km` is expected is exactly as wrong as a type mismatch between
`int` and `string` — the type system prevents it without any runtime overhead.

## The real-world pattern

In production Mercury, phantom types appear for:
- Physical units (length, time, mass)
- Currency (USD vs EUR vs JPY)
- Encoding safety (raw bytes vs UTF-8 vs HTML-escaped strings)
- Capability tokens (read-only vs read-write handles)

The pattern scales because `add_lengths` stays fully polymorphic in `U` — a single
predicate works for all unit types, with per-call-site enforcement.
