# Koan: property generator must be nondet

## What to observe

Compile `prop_gen_koan.m`:

```
mmc --make prop_gen_koan
```

The error:

```
prop_gen_koan.m:57:   in argument 2 of call to predicate `check_property/5':
prop_gen_koan.m:57:   mode error: variable `V_7' has instantiatedness
prop_gen_koan.m:57:   `/* unique */ (pred(out) is det)',
prop_gen_koan.m:57:   expected instantiatedness was `(pred(out) is nondet)'.
```

The runner `check_property` passes the generator to `solutions/2`, which requires `(pred(out) is nondet)`. The generator `gen_one_int` is declared `det`, so it doesn't match.

## Your task

Fix `gen_one_int` so it:

1. Is declared `nondet`
2. Generates a range of values rather than a single hard-coded one

Use `int.nondet_int_in_range(Low, High, N)` — Mercury 22's bounded integer generator. It generates every integer from `Low` to `High` inclusive via backtracking.

## What to learn

A `det` generator produces exactly one test case. If the property happens to hold for that case, the test passes — but every other value in the domain goes unchecked. That is not property testing; it is a single example test wearing the wrong costume.

The whole point of a generator is to enumerate a space of inputs. That requires `nondet`.
