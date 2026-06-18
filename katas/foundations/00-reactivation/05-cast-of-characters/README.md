# 05 — Cast of Characters

**Concept:** named-field ADTs, `^field` accessor syntax, multi-clause `func`, named-predicate vs. inline-lambda `foldl`

**Before you open the files:** this directory contains two programs — `people.m` and `people_alt.m`. They implement the same fold over a list of records, one using a named helper predicate, one using an inline lambda. Write down what you remember about how `foldl` works in Mercury — what are its arguments, in what order, and what does the accumulator look like?

---

## What to look for

### Named-field ADTs

Mercury lets you define record-like types with named fields:

```mercury
:- type person ---> person(name :: string, age :: int).
```

The `^field` syntax retrieves a field from a value: `Person^name` extracts the `name` field. This is purely syntactic — no runtime dispatch, no dictionary lookup. The compiler knows the layout at compile time.

### `foldl` two ways

`people.m` passes a named predicate to `foldl`. `people_alt.m` passes an inline lambda (`(pred(X, !Acc) is det :- ...)`). The fold itself is identical — what changes is only how the per-element operation is expressed.

Read both. Note which form feels more readable for a short operation vs. a longer one. There is no single right answer, but noticing the tradeoffs is the exercise.

### Determinism of the fold predicate

The predicate passed to `foldl` must have a specific mode and determinism. Notice what it is, and think about why — what would happen if the per-element operation could fail?

## After reading

Could you say:
- What does `^field` expand to under the hood — is it a function call, a record access, or something else?
- In what situation would you prefer the named-predicate form over the inline lambda?
