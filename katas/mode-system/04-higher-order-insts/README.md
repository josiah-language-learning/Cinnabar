# 04 — Higher-order insts: dispatch tables

**Concept:** `map(string, pred(...) is det)` dispatch tables, inst annotations on stored
predicates, the compile error without annotations, why different modes cannot coexist in
one container

**Not in the Mercury tutorial.** This is the mode-system companion to `katas/foundations/04-higher-order`.

---

## What you will build

A dispatch table: a `map(string, pred(int, int) is det)` that maps names to integer
transformations. Look up a name, apply the transform.

---

## Exercise 1: Named inst for stored predicates

```mercury
:- inst int_transform == (pred(in, out) is det).
```

The dispatch table type:
```mercury
:- type transform_table == map(string, pred(int, int)).
```

Wait — `pred(int, int)` has no inst annotation. Try to store a predicate in this map
and call it via `call/2`. You will get a mode error when attempting the call: Mercury
does not know the inst of the value retrieved from the map.

Fix: you cannot directly parameterise a `map` value type with an inst. Use a wrapper:

```mercury
:- type transform ---> transform(pred(int, int) :: (pred(in, out) is det)).
```

Or use a `func` instead of a `pred`:

```mercury
:- type transform_table == map(string, func(int) = int).
```

`func(int) = int` has an implied inst of `(func(in) = out is det)`. Try both approaches.

## Exercise 2: Build and use the table

```mercury
:- func double(int) = int.
double(N) = N * 2.

:- func negate(int) = int.
negate(N) = -N.

:- func add_ten(int) = int.
add_ten(N) = N + 10.

build_table = Table :-
    map.from_assoc_list([
        "double"   - double,
        "negate"   - negate,
        "add_ten"  - add_ten
    ], Table).
```

Look up a name from a command-line argument, apply the transform to a hardcoded input,
print the result.

## Exercise 3: Why mixed modes cannot coexist

Try to store `double` (a `func(int) = int`) and a `pred(int, int, io, io) is det`
in the same map. They have different types — Mercury's type system prevents this, not just
the mode system. This is fundamentally different from OOP, where methods with different
signatures can coexist in a vtable.

The solution: existential types (see `katas/type-system/05-existential-types`).

---

## Checkpoint

- Dispatch table with `func(int) = int` values builds
- Lookup + application works from command-line input
- You can explain: why does `pred(int, int)` without an inst cause a mode error on call?
- You can explain: why cannot predicates with different modes share one map?
