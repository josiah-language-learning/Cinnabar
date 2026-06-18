# 08 — Instance coherence

**Concept:** the global coherence rule; orphan instances; newtype wrappers as the
solution; Mercury vs. Haskell on this design choice

**Not in the Mercury tutorial.**

---

## The coherence rule

Mercury permits **at most one instance** of a typeclass per type, globally, across all
modules. This is called *instance coherence*. Call `to_str(42)` anywhere in the program
and you get the same result, regardless of which modules are imported.

In Haskell, a library can define an instance for a type from another library — an
*orphan instance*. Two libraries can independently define `Show MyInt` with different
behaviour. When both are imported, the result is undefined or ambiguous. Haskell warns
about orphans but allows them.

Mercury forbids orphan instances at the language level. Every instance must be defined
in either:
- the module that defines the typeclass, or
- the module that defines the type.

Attempting an orphan instance is a compile error.

---

## Parametric instances

Instances can be parametric — `printable(list(T))` given `printable(T)`:

```mercury
:- instance printable(list(T)) <= printable(T) where [
    to_str(Xs) = "[" ++ list_str(Xs) ++ "]"
].
```

The constraint `<= printable(T)` means: this instance exists for any `T` that already
has a `printable` instance. `to_str([1,2,3])` uses `printable(int)` for each element;
`to_str([["a","b"],["c"]])` uses `printable(list(string))` recursively.

---

## Instance proliferation and newtype wrappers

You cannot write two `printable(float)` instances even if they would produce different
output. The coherence rule makes the second a compile error.

The solution is **newtype wrappers** — thin wrapper types that carry the same data
but have distinct type identities:

```mercury
:- type standard_float   ---> standard_float(float).
:- type scientific_float ---> scientific_float(float).

:- instance printable(standard_float) where [ ... ].
:- instance printable(scientific_float) where [ ... ].
```

The caller wraps the value to select the representation:

```mercury
to_str(standard_float(3.14))   % → "3.14"
to_str(scientific_float(3.14)) % → "3.14e0"
```

This is the standard Mercury pattern wherever different instances of the same typeclass
are needed for the same underlying type.

---

## The `tagged` wrapper

A parametric newtype wraps any `T` with a string label:

```mercury
:- type tagged(T) ---> tagged(string, T).

:- instance printable(tagged(T)) <= printable(T) where [
    to_str(tagged(Tag, Val)) = Tag ++ ":" ++ to_str(Val)
].
```

One instance covers `tagged(int)`, `tagged(string)`, `tagged(list(float))`, etc. The
constraint `<= printable(T)` ensures `to_str(Val)` is always available.

---

## What you will build

### `printable(T)` typeclass

Single method `func to_str(T) = string`. Instances for `int`, `float`, `string`.

### `printable(list(T)) <= printable(T)`

Parametric instance. Output: `"[1, 2, 3]"` for `[1,2,3]`, `"[[1, 2], [3]]"` for nested.

### `standard_float` and `scientific_float` newtypes

Two wrappers for `float`, each with its own `printable` instance. Demonstrates that
two representations of the same data require two types.

### `tagged(T)` parametric wrapper

Generic `tagged(string, T)` with a `printable(tagged(T))` instance.

---

## Checkpoint

- `to_str([1,2,3]) = "[1, 2, 3]"` and `to_str([[1,2],[3]]) = "[[1, 2], [3]]"`
- `to_str(standard_float(3.14))` and `to_str(scientific_float(3.14))` differ
- `to_str(tagged("score", 99)) = "score:99"`
- You can state: what makes an instance an "orphan" and why does Mercury forbid them?
- You can state: what is the newtype wrapper pattern and what problem does it solve?
