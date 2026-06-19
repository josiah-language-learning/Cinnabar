# Koan: `!X` is not allowed in lambda argument lists

**Broken concept:** using the `!Acc` shorthand in a lambda head instead of
explicit `Acc0::in, Acc::out` mode annotations

## Prerequisites

- `katas/foundations/04-higher-order` — lambdas, `call/N`, `list.foldl`

---

```
mmc foldl_koan.m
```

The error is: "`!Acc` cannot be a lambda argument. Perhaps you meant `!.Acc` or `!:Acc`."

---

## What to observe

The `!X` shorthand expands to a `di`/`uo` or `in`/`out` pair — but *only* in
call positions, not in argument declarations. Lambda heads require each argument
to be declared separately with an explicit mode annotation:

```mercury
pred(X::in, Acc0::in, Acc::out) is det
```

The `!Acc` shorthand is valid when *calling* a predicate:
```mercury
list.foldl(my_pred, Xs, !Acc)   % OK: call position, expands to !.Acc, !:Acc
```

It is not valid in the lambda head itself. This is because the two positions
(`in` and `out`) need to be given separate names — `Acc0` for the value going
*in* and `Acc` for the value coming *out* — so that the body can reference both.

---

## Your task

Replace `!Acc` in the lambda head with `Acc0::in, Acc::out`. Update the body to
read from `Acc0` and write to `Acc`: `Acc = Acc0 + X`.
