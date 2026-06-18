# Solution notes

## Existential type construction in Mercury 22

The puzzle description mentions existential types (`some [T] plugin(T) => formatter(T)`),
but Mercury 22.01 does not allow constructing existential types from arbitrary clause
positions. Attempting:

```mercury
:- type plugin ---> some [T] plugin(T) => formatter(T).

mk_upper = plugin(upper).  % compile error
```

produces:

```
type error in unification of argument and constant `upper'.
argument has type `(some [T] T)',
constant `upper' has type `plugins.upper'.
```

Mercury's type checker represents the inner argument of an existentially quantified
constructor as `(some [T] T)` — an existential type — and refuses to unify it with
a concrete type like `upper`. The "packing" of existentials is not available from
regular clause heads in this version. (Deconstruction — pattern matching on
`plugin(X)` to bring T into scope — works fine.)

## The closure alternative

Storing behavior as a first-class function closure achieves the same open-world
property without existential types:

```mercury
:- type plugin
    --->    plugin(
                pname  :: string,
                papply :: func(string) = string
            ).
```

New plugins are defined by providing name and function — no changes to the core
system:

```mercury
mk_upper = plugin("upper", string.to_upper).
mk_repeat(N) = plugin("repeat(" ++ N_str ++ ")", func(S) = repeat_str(N, S)).
mk_prepend(P) = plugin("prepend(\"" ++ P ++ "\")", func(S) = P ++ S).
```

The `repeat` and `prepend` variants capture their data (N, P) in the closure — the
same role existential types would play. The typeclass dictionary is replaced by the
explicit function value. Runtime cost is equivalent: one extra pointer indirection.

## Calling a stored function

Named record field access returns the closure:

```mercury
Output = (P ^ papply)(Input)
```

`P ^ papply` extracts the function; applying it with `(F)(X)` syntax calls it.
This is Mercury's functional application syntax for higher-order values.

## Heterogeneous list without existentials

`list(plugin)` holds values of different "logical types" (upper, repeat, prepend)
behind a uniform interface. The union is *nominal* — the record type — rather than
existential. The practical difference: you can't add new plugin methods later
without changing the record type. A real existential would allow extending the
API (add `name_of/1` to the typeclass) without touching existing plugins.

## Answering the design questions

**Q1: Why can't you call `apply` directly from the outside?**
With existential types, once T is hidden in `some [T] T`, the outer scope cannot
call `apply(X, S)` because the type of X is unknown. You must go through a
predicate that deconstructs the box and brings T (with its constraint) back into
scope. In the closure version, there is no T to hide — the function is already
specialized.

**Q2: Can you compose two plugins?**
With the closure approach, trivially:
```mercury
compose(P1, P2) = plugin(
    P1 ^ pname ++ " | " ++ P2 ^ pname,
    func(S) = (P2 ^ papply)((P1 ^ papply)(S))).
```
With existential types, `compose(plugin(X), plugin(Y))` would need a new
existential type `some [A, B] compose_plugin(A, B) => (formatter(A), formatter(B))`,
which adds complexity without much gain.

**Q3: Runtime cost vs Rust `Box<dyn Trait>`**
Both models store a pointer to a vtable (Mercury) or trait object (Rust).
Mercury's existential packs `(value, class_dictionary_pointer)`. Rust's
`Box<dyn Trait>` stores `(data_pointer, vtable_pointer)`. The costs are the same
order — one extra indirection per method call. The closure version avoids the
dictionary but requires one closure allocation per plugin.
