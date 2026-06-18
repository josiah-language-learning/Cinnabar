# 05 — Existential types: heterogeneous containers

**Concept:** `some [T]` existential quantification, `=> typeclass(T)` constraint on
existential constructors, OOP-style dispatch without OOP, `deconstruct` to unwrap

**Not in the Mercury tutorial.** This is Tier 3 material — read `04-type-classes` first.

---

## What you will build

A heterogeneous list of `printable` values — a list that can hold an `int`, a `string`,
and a `point` all at once, dispatching to the right `print_item` at runtime.

### The existential type

```mercury
:- type any_printable
    --->    some [T] wrap(T) => printable(T).
```

This reads: "an `any_printable` value is a `wrap(T)` for some type `T`, where `T` has a
`printable` instance." The type `T` is *existentially quantified* — the caller does not
know which `T` it is, only that some concrete type is hidden inside.

### Wrap values

```mercury
:- func wrap_int(int) = any_printable.
wrap_int(N) = 'new wrap'(N).

:- func wrap_point(point) = any_printable.
wrap_point(P) = 'new wrap'(P).
```

`'new wrap'(V)` is the syntax for constructing a value with an existential constructor.
The single quotes and `new` are mandatory — they tell the compiler this is an existential
construction.

### Iterate and dispatch

```mercury
:- pred print_any(any_printable::in, io::di, io::uo) is det.
print_any(wrap(V), !IO) :-
    print_item(V, !IO).
```

Pattern-matching on the existential constructor `wrap(V)` brings `V` into scope with its
typeclass constraint intact. The compiler knows `V` is printable (because the constructor
required it), so `print_item(V, !IO)` resolves correctly.

### Build and iterate the list

```mercury
Items = [
    wrap_int(42),
    'new wrap'("hello"),
    wrap_point(point(1.5, 2.5))
],
list.foldl(print_any, Items, !IO).
```

### Connection to OOP

This is the Mercury equivalent of:
```python
class Printable:
    def print_item(self): ...
```
...but without inheritance, vtables, or runtime casts. The typeclass instance is resolved
at the `wrap` site; the unwrap dispatch is a compile-time-verified call.

---

## Checkpoint

- The heterogeneous list builds with all three types
- `print_any` dispatches correctly to each type's `print_item`
- You can explain: why does the compiler accept `print_item(V, !IO)` inside the
  `wrap(V)` pattern match, given that it does not know the concrete type of `V`?
- You can explain: what would you need to change to add a second method to the typeclass
  and use it in `print_any`?
