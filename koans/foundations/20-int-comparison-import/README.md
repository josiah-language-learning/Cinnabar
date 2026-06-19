# Koan: integer comparison operators require `import_module int`

**Broken concept:** using `>`, `<`, `>=`, or `=<` without importing the module
that defines them

## Prerequisites

- `katas/foundations/` — integers, if-then-else

---

```
mmc int_cmp_koan.m
```

Two errors fire, one per operator used:

```
error: undefined predicate `>'/2.
error: undefined predicate `<'/2.
```

Fix: add `import_module int` to the implementation section.

---

## What to observe

Integer comparison operators are **not** built into Mercury's core language.
They are predicates defined in the `int` module:

```mercury
:- pred int.'>'(int::in, int::in) is semidet.
:- pred int.'<'(int::in, int::in) is semidet.
:- pred int.'>='(int::in, int::in) is semidet.
:- pred int.'=<'(int::in, int::in) is semidet.
```

Without `import_module int`, all four are `undefined predicate` errors.

**Note on `=<`:** Mercury uses `=<` (not `<=`) for "less than or equal"
because `<=` is already taken — it is the typeclass constraint syntax
(e.g., `pred foo(T) <= show(T)`).

---

## Your task

Add `import_module int` to the implementation section. All four comparison
operators become available with a single import.
