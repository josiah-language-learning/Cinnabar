# 06 — Typeclass depth: superclasses, multi-param, and functional dependencies

**Concept:** superclass constraints with `<=`; multi-parameter typeclasses; functional
dependencies (`|`); instance coherence

**Not in the Mercury tutorial.**

---

## Superclasses

A typeclass can require another typeclass as a precondition. The `<=` syntax adds
superclass constraints:

```mercury
:- typeclass printable(T) <= show(T) where [
    pred print_item(T::in, io::di, io::uo) is det
].
```

Any type `T` that is `printable` must also have a `show` instance. The superclass
constraint propagates: a predicate `print_all <= printable(T)` implicitly also has
`show(T)` available.

---

## Multi-parameter typeclasses

Typeclasses can range over more than one type variable:

```mercury
:- typeclass convertible(From, To) where [
    func convert(From) = To
].
```

Instances:
```mercury
:- instance convertible(int, string) where [
    convert(N) = string.int_to_string(N)
].
:- instance convertible(float, string) where [
    convert(F) = string.float_to_string(F)
].
```

The two instances are distinct because they have different `(From, To)` pairs.

---

## Functional dependencies

Without a functional dependency, `convertible(int, string)` and `convertible(int, float)`
can coexist — but calling `convert(42)` becomes ambiguous: which instance?

A functional dependency `| From -> To` means: the `To` type is *determined by* the
`From` type. Once `From` is fixed, `To` is uniquely determined:

```mercury
:- typeclass convertible(From, To) <= ((From -> To)) where [
    func convert(From) = To
].
```

Now, `convertible(int, string)` and `convertible(int, float)` cannot both exist —
having two `To` types for the same `From` would violate the dependency. The compiler
rejects the second instance.

---

## What you will build

### `show` and `printable` typeclass hierarchy

```mercury
:- typeclass show(T) where [ func show(T) = string ].

:- typeclass printable(T) <= show(T) where [
    pred print_item(T::in, io::di, io::uo) is det
].
```

Write instances for `int` and a custom `point ---> point(float, float)` type.

### `convertible(From, To)` with FD

Write the `convertible` typeclass with functional dependency.
Provide instances for `(int, string)` and `(float, string)`.
Add a comment showing that `(int, float)` would be a compile error — the FD forbids
two different `To` types for the same `From`.

---

## No default method implementations

Mercury typeclasses do not support default method implementations. Every instance must
explicitly define every method. This is a deliberate design choice — it prevents hidden
behaviour from default implementations shadowing instance-specific logic.

---

## Instance coherence

Mercury enforces *global* instance coherence: at most one instance per
typeclass/type-pair combination, across all modules. Two modules cannot both define
`show(int)`. This prevents the Haskell "orphan instance" class of bugs where the same
type gets different behaviour in different modules.

---

## Checkpoint

- `show(42)` returns `"42"` and `show(point(1.0, 2.0))` returns a reasonable string
- `print_item` compiles for both `int` and `point`
- `convertible(int, string)` and `convertible(float, string)` instances compile
- You can state: what does the FD `From -> To` forbid?
- You can state: what is "instance coherence" and why does Mercury require it?
