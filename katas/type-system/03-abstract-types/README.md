# 03 — Abstract types: representation independence

**Concept:** opaque types, withholding constructors from the interface, encapsulation
enforcement, the compile error when client code pattern-matches on a hidden constructor

**Tutorial cross-reference:** Mercury Tutorial §5 covers the interface/implementation
split. Withholding constructors to create abstract types is not covered.

---

## What you will build

An opaque `counter` type. Two modules:
- `counter.m` — defines the type and its operations
- `counter_client.m` — a program that uses `counter` through its interface only

### `counter.m`

**Interface section** (all that clients see):

```mercury
:- module counter.
:- interface.
:- import_module io.

:- type counter.

:- func init(int) = counter.
:- func value(counter) = int.
:- pred increment(counter::in, counter::out) is det.
:- pred decrement(counter::in, counter::out) is det.
:- pred reset(counter::in, counter::out) is det.
```

Notice: `:- type counter.` declares that the type *exists*, but says nothing about its
structure. Clients know it exists; they do not know what it is made of.

**Implementation section** (private):

```mercury
:- implementation.

:- type counter ---> counter(value :: int).

init(N) = counter(N).
value(counter(N)) = N.
increment(counter(N), counter(N + 1)).
decrement(counter(N), counter(N - 1)).
reset(_, counter(0)).
```

### `counter_client.m`

Write a client that:
1. Creates a counter with `counter.init(10)`
2. Increments it three times
3. Prints the value

This works fine. Now add a line that pattern-matches on the internal constructor:

```mercury
counter(N) = MyCounter,  % ERROR: constructor not visible
```

Build and read the compiler error. It should say something about the constructor
`counter/1` not being visible or not being part of the type's exported interface.

Remove the broken line, confirm the client builds.

### Why this matters

The `counter` type could change its internal representation (to `counter(int, int)` for
min/max tracking, or to a mutable) without breaking any client code. The interface is the
contract; the implementation is the secret.

This is representation independence — the same guarantee that abstract data types in any
language provide, enforced at compile time by the module system.

---

## Checkpoint

- `counter.m` compiles as a module
- `counter_client.m` can use all exported operations
- The pattern-match on `counter(N)` gives a compile error
- You can explain: what must change in `counter.m`'s interface if you want clients to
  be able to pattern-match on `counter`?
