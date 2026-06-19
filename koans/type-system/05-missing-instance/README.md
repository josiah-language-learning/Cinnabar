# Koan: no instance for concrete type

**Broken concept:** using a typeclass method on a concrete type that has no instance
declared — an unsatisfiable typeclass constraint

## Prerequisites

- `katas/type-system/03-typeclasses` — typeclass declarations and instance syntax

---

In Mercury, typeclass constraints are checked entirely at compile time. If a predicate
calls a typeclass method on a concrete type (`color`, `int`, `shape`) and no
`instance` declaration exists for that type, the compiler rejects the program with
"unsatisfiable typeclass constraint". There is no runtime fallback.

---

## Try it

```
mmc --make instance_koan
```

The compiler reports that the `show` constraint cannot be satisfied for
`instance_koan.color` — the instance simply does not exist.

---

## What to observe

`show` has an instance for `int` but not for `color`. When `print_color` calls
`show(C, Str)` with `C :: color`, the compiler cannot find any evidence that `color`
satisfies `show`. The solution is straightforward: write the missing instance.

---

## Your task

Add an `instance show(color)` declaration with a clause for each constructor
(`red`, `green`, `blue`). The predicate `print_color` should then compile without changes.
