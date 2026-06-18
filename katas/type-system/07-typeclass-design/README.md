# 07 — Typeclass design: when to use a typeclass vs. higher-order

**Concept:** the design decision between typeclasses and higher-order predicates;
instance proliferation; newtype wrappers as the solution

**Not in the Mercury tutorial.**

---

## When to use a typeclass

Use a typeclass when you need **multiple related operations** that must be implemented
consistently, and the instance should be reusable across the codebase without being
passed explicitly:

```mercury
:- typeclass serializable(T) where [
    func serialize(T) = string
].
```

The constraint `<= serializable(T)` propagates through the type system — a predicate
that calls `serialize` just declares the constraint; the caller's caller's caller
handles providing the instance. No plumbing.

---

## When to use higher-order

Use higher-order when you need **a single operation** or want to swap implementations
at runtime:

```mercury
:- func ho_serialize_list(func(T) = string, list(T)) = string.
```

The function is passed explicitly. At the call site, you choose the implementation:

```mercury
ho_serialize_list(string.int_to_string, [1, 2, 3])
ho_serialize_list((func(N) = "0x" ++ int_to_hex(N)), [16, 255])
```

The tradeoff: higher-order is more flexible at the call site (swap implementations per
call), but more verbose (you carry the function everywhere). Typeclasses are less
flexible but cleaner — once an instance is defined, it's used automatically.

---

## Instance proliferation

The typeclass approach has a sharp limitation: **at most one instance per type**. If
you want two different serializations of `int`, you cannot write:

```mercury
% ILLEGAL — two instances of serializable(int):
:- instance serializable(int) where [ serialize(N) = string.int_to_string(N) ].
:- instance serializable(int) where [ serialize(N) = "0x" ++ int_to_hex(N) ].
```

Mercury's coherence rule forbids this. The compiler rejects it.

---

## Newtype wrappers: the solution

Wrap the type in a distinct constructor. Each wrapper is a distinct type and can have
its own instance:

```mercury
:- type decimal ---> decimal(int).
:- type hex     ---> hex(int).

:- instance serializable(decimal) where [
    serialize(decimal(N)) = string.int_to_string(N)
].
:- instance serializable(hex) where [
    serialize(hex(N)) = "0x" ++ int_to_hex_str(N)
].
```

Now `serialize(decimal(42)) = "42"` and `serialize(hex(42)) = "0x2a"` both compile.
The caller chooses which serialization by wrapping the value.

The cost: you have to wrap and unwrap. For small programs this feels like boilerplate;
for large codebases it is documentation — `decimal(42)` says something about intent
that `42` alone does not.

---

## What you will build

### `serializable(T)` typeclass

A single method `func serialize(T) = string`. Instances for `int`, `float`, `string`.

### `serialize_list(list(T)) = string`

Recursively serialize a list using the typeclass. Output: `"[1, 2, 3]"` for `[1,2,3]`.

### `ho_serialize_list(func(T) = string, list(T)) = string`

Same result, but takes the serializer as an explicit higher-order argument instead of
using the typeclass.

### `decimal` and `hex` newtypes

Newtype wrappers for `int`. Each with its own `serializable` instance.
`serialize(hex(255))` → `"0xff"`.

---

## Checkpoint

- `serialize(42) = "42"`, `serialize("hi") = "\"hi\""`
- `serialize_list([1,2,3]) = "[1, 2, 3]"`
- `ho_serialize_list(...)` gives the same result as `serialize_list` for the same input
- `serialize(decimal(42)) = "42"`, `serialize(hex(42)) = "0x2a"`
- You can state: why does Mercury forbid two instances of `serializable(int)`?
- You can state: when is a newtype wrapper the right tool and when is higher-order better?
