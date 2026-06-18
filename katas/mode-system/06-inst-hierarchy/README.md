# 06 — The inst hierarchy

**Concept:** user-defined `bound(...)` insts, parametric insts, inst subtyping; how Mercury
tracks what values are possible at each point

**Not in the Mercury tutorial.**

---

## What an inst describes

An *inst* (instantiation state) describes what is known about a variable's value at a
given program point. The built-in insts form a lattice:

| Inst | Meaning |
|---|---|
| `free` | completely uninstantiated |
| `bound(f(...))` | bound to a specific functor (or disjunction of functors) |
| `ground` | fully instantiated to any value |
| `unique` | the only live reference; permits destructive update |
| `clobbered` | a unique value that has been consumed |
| `any` | may be free or bound (solver type contexts) |

`ground` is shorthand for `bound(...)` with all sub-insts `ground`. Every `ground` value
is also `bound`; every `bound` value is a subtype of `ground`.

---

## User-defined bound insts

Restrict a variable to a specific set of values:

```mercury
:- inst die_face == bound(1 ; 2 ; 3 ; 4 ; 5 ; 6).
```

A predicate that produces only valid die faces:
```mercury
:- pred roll(int::out(die_face)) is det.
roll(1).   % stub: use a random or hardcoded value
```

A predicate that requires a valid die face as input:
```mercury
:- func double_face(int::in(die_face)) = (int::out) is det.
double_face(N) = N * 2.
```

If you pass an arbitrary `int` to `double_face`, Mercury reports a mode error — the
actual inst (`ground`) is not a subtype of the required inst (`die_face`).

---

## Parametric insts

Insts can be parameterised over other insts, just as types are parameterised over types:

```mercury
:- inst list_of(I) == bound([] ; [I | list_of(I)]).
```

A function returning a list of die faces:
```mercury
:- func three_rolls = (list(int)::out(list_of(die_face))).
three_rolls = [1, 2, 3].
```

The inst `list_of(die_face)` means: a list whose elements all satisfy `die_face`.

---

## Insts on ADT constructors

You can restrict a `maybe` to the `yes` case:

```mercury
:- inst yes_int == bound(yes(ground)).

:- func unwrap_yes(maybe_int::in(yes_int)) = (int::out) is det.
unwrap_yes(yes(N)) = N.
```

Calling `unwrap_yes(no)` is a mode error caught at compile time. The inst annotation
makes the "this can only be called with a `yes` value" constraint explicit and checked.

---

## What you will build

### Die face inst and predicates

Define `die_face`, write `roll/1` and `double_face/1`.

### Parametric list inst

Define `list_of/1` and write `three_rolls` using it.

### `yes_int` inst and `unwrap_yes`

Define `maybe_int`, the `yes_int` inst, and `unwrap_yes`. Confirm it compiles. Then
try calling it with `no` to see the mode error.

---

## Checkpoint

- `roll` compiles with `out(die_face)` annotation
- `double_face` compiles; calling it with a plain `int` gives a mode error
- `three_rolls` compiles with `out(list_of(die_face))`
- `unwrap_yes(yes(42))` compiles; `unwrap_yes(no)` gives a mode error
- You can state: what is the relationship between `ground` and `bound(...)` in the inst lattice?
