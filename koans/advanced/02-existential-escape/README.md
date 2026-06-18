# Koan: constructing an existential type

## Prerequisites
- `katas/advanced/03-rtti`
- `katas/type-system/05-existential-types`

An existential type hides its type parameter from the outside:

```mercury
:- type tagged
    --->    some [T] tagged(string, T).
```

Constructing a value of this type requires the `'new Constructor'` syntax. The ordinary constructor syntax does not apply.

Compile this:

```
mmc --make existential_koan
```

---

When you write `tagged(Label, Value)`, Mercury treats this as a pattern match or a call to a known functor — but `T` is universally quantified from the outside. There is no way to bind `T` at the call site with that syntax.

The `'new Constructor'` syntax tells Mercury: introduce a fresh existential binding for `T`, inferred from the type of `Value`:

```mercury
'new tagged'(Label, Value)
```

The quotes and `new` keyword are required. Without them the compiler cannot tell you are introducing an existential rather than applying a known constructor.

The same restriction applies in any position where you build a value of an existentially quantified type.

---

## What to observe

The error message will reference "existential type" or "universally quantified" and point
to the constructor call. Notice that *pattern matching* on `tagged(Label, Value)` (in a
`some [T]` clause head) works — the `'new'` syntax is only needed when *constructing*.

---

## Your task

Replace `tagged(Label, Value)` in the construction site with `'new tagged'(Label, Value)`.
Recompile. Then try pattern-matching on the result — do you need `'new'` there?
