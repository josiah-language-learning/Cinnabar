# Koan: `=\=` — the Prolog arithmetic inequality that doesn't exist in Mercury

**Broken concept:** using Prolog's arithmetic inequality operator `=\=`, which
Mercury does not define

## Prerequisites

- `katas/foundations/` — arithmetic and comparison

---

```
mmc int_ops_koan.m
```

Error: `undefined predicate '=\='/2`

---

## What to observe

Mercury does not have Prolog's arithmetic comparison operators `=:=` and `=\=`.
Use structural equality and inequality instead:

```mercury
( X \= 0 -> ... ; ... )   % structural inequality: succeeds when X ≠ 0
( X = 0 -> ... ; ... )    % unification: succeeds when X = 0
```

For ground integers, `=` and `\=` behave as arithmetic comparison because
unification on ground terms compares values.

Note: both `/` and `//` are valid integer division operators in Mercury 22 —
they produce the same result (truncating division toward zero). The operator
confusion is a Prolog carry-over that no longer applies.

---

## Your task

Replace `=\=` with `\=`.
