# 04 — Type classes: ad-hoc polymorphism

**Concept:** `:- typeclass`, instance declarations, constraint syntax (`<= typeclass(T)`),
the no-default-methods rule

**Not in the Mercury tutorial.**

---

## What you will build

A `printable` typeclass with instances for `int`, `string`, and a custom type.

### Define the typeclass

```mercury
:- typeclass printable(T) where [
    pred print_item(T::in, io::di, io::uo) is det
].
```

A typeclass declares a *family of predicates* that any instance must provide. `printable(T)`
says: "any type T can be printable if it provides `print_item/3`."

### Write instances

```mercury
:- instance printable(int) where [
    pred(print_item/3) is print_int
].

:- pred print_int(int::in, io::di, io::uo) is det.
print_int(N, !IO) :- io.format("%d", [i(N)], !IO).

:- instance printable(string) where [
    pred(print_item/3) is print_str
].

:- pred print_str(string::in, io::di, io::uo) is det.
print_str(S, !IO) :- io.write_string(S, !IO).
```

Now a custom type:
```mercury
:- type point ---> point(x :: float, y :: float).

:- instance printable(point) where [
    pred(print_item/3) is print_point
].

:- pred print_point(point::in, io::di, io::uo) is det.
print_point(point(X, Y), !IO) :-
    io.format("(%.2f, %.2f)", [f(X), f(Y)], !IO).
```

### Use the constraint in a polymorphic predicate

```mercury
:- pred print_list(list(T)::in, io::di, io::uo) is det <= printable(T).
print_list([], !IO).
print_list([H | T], !IO) :-
    print_item(H, !IO),
    io.write_string("\n", !IO),
    print_list(T, !IO).
```

`<= printable(T)` is the constraint: "this predicate works for any T that has a
`printable` instance." The compiler checks at each call site that `T` is indeed printable.

Test it with `print_list([1, 2, 3], !IO)`, `print_list(["a", "b"], !IO)`,
and `print_list([point(1.0, 2.0), point(3.0, 4.0)], !IO)`.

### No default methods

Try adding a default method to the typeclass:

```mercury
% what you might want, but Mercury does not support default methods:
:- typeclass printable(T) where [
    pred print_item(T::in, io::di, io::uo) is det,
    func label(T) = string
].
```

Mercury does not support default method implementations in typeclasses. Every instance must
define every method. This is a deliberate restriction — it avoids the "diamond problem"
complexity and keeps instance declarations explicit.

---

## Checkpoint

- All three instances compile
- `print_list` works for all three element types
- Attempting to use `print_list` with a type that has no `printable` instance gives a
  compile error naming the missing instance
- You can explain: what is the difference between a typeclass constraint and an abstract type?
