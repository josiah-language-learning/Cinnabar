# 03 — Uniqueness: arrays and the di/uo discipline

**Concept:** `array(T)`, `array_di`/`array_uo` modes, uniqueness loss in disjunctions,
`version_array` as the solution for shared access

**Tutorial cross-reference:** Mercury Tutorial shows `di`/`uo` on `!IO`. Array uniqueness
is the same mechanism applied to a different type, and exposes the constraint more directly.

---

## The uniqueness model

`di` (destructive input) means the caller hands over exclusive ownership of the value — no
one else has a reference, and after the call the caller must not use the old value.
`uo` (unique output) means the result is freshly created and the caller has exclusive ownership.

For `!IO`, this is invisible: there is only ever one IO state. For arrays, the constraint
becomes concrete — two references to the same array cannot exist simultaneously.

---

## Exercise 1: Create and mutate an array

```mercury
:- import_module array.

main(!IO) :-
    array.init(5, 0, Arr0),
    array.set(0, 42, Arr0, Arr1),
    array.set(1, 99, Arr1, Arr2),
    io.write_line(array.to_list(Arr2), !IO).
```

`array.set/4` takes `array_di` and produces `array_uo` — it "consumes" `Arr0` and
produces a new (possibly mutated in-place) `Arr1`. After calling `array.set(0, 42, Arr0, Arr1)`,
you cannot use `Arr0` again. The compiler enforces this.

## Exercise 2: Trigger uniqueness loss

Try to use the same array in two branches:

```mercury
( Condition ->
    array.set(0, 1, Arr, Arr1)
;
    array.set(0, 2, Arr, Arr1)
).
```

This fails to compile. In the `->` branch, `Arr` is consumed. The compiler cannot guarantee
that `Arr` is unique at the start of the else branch — it was already consumed in the then
branch. Read the error carefully.

## Exercise 3: `version_array` for shared access

```mercury
:- import_module version_array.
```

`version_array(T)` is a persistent array with functional update semantics. `varray.set/3`
returns a new version without consuming the old one:

```mercury
varray.set(Arr, 0, 42) = Arr1,
varray.set(Arr, 0, 99) = Arr2.
% Both Arr1 and Arr2 are accessible; Arr is not consumed.
```

Rewrite exercise 2's branching logic using `version_array`. Confirm it compiles.

The cost: `version_array` may copy on update (like a persistent functional structure).
For most use cases, this is acceptable. For performance-critical mutation, you need
genuine unique arrays.

---

## Checkpoint

- Exercise 1: array init + two sets + print builds correctly
- Exercise 2: the disjunction error is triggered and read
- Exercise 3: `version_array` version compiles with branching
- You can state: when should you use `array` vs `version_array`?
