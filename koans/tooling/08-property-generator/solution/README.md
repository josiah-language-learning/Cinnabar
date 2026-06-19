# Solution: property generator must be nondet

## The fix

Change the generator declaration from `det` to `nondet` and generate a range:

```mercury
:- pred gen_small_int(int::out) is nondet.
gen_small_int(N) :- int.nondet_int_in_range(-10, 10, N).
```

`int.nondet_int_in_range/3` is Mercury 22's bounded integer generator (note: NOT
`int.between/3` — that name does not exist in Mercury 22's `int` module). It
backtracks from `Low` to `High` inclusive, producing 21 cases here.

## Note on int.nondet_int_in_range

Mercury 22 names the range predicate `int.nondet_int_in_range`, not `int.between`
(a common name in other languages and later Mercury versions). The name makes the
determinism explicit, which is consistent with Mercury's philosophy of declaring
intent in identifiers.

## Why the false fix doesn't work

A tempting wrong fix: keep `det` and expand the body to match multiple clauses:

```mercury
:- pred gen_one_int(int::out) is det.  % still declared det
gen_one_int(-10).
gen_one_int(0).
gen_one_int(10).
```

This still fails: three clauses each producing one value infer `nondet`, and the
compiler rejects `det` with inferred `nondet`. The declaration must match the
actual behavior.
