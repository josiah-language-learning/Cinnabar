# 09 — Phantom types

**Concept:** a phantom type parameter that appears in no constructor; unit-safe
arithmetic; compile-time state machines

**Not in the Mercury tutorial.**

---

## What is a phantom type?

A phantom type carries a type parameter that does **not** appear in any constructor:

```mercury
:- type quantity(Unit) ---> quantity(float).
```

`Unit` is "phantom" — it exists at the type level but is erased at runtime. Two values
of type `quantity(metres)` and `quantity(seconds)` have identical runtime representations
(both are just a `float`), but the compiler treats them as different types and refuses to
mix them.

---

## Unit tags

The phantom parameter is a type that exists only to be used as a tag:

```mercury
:- type metres            ---> metres_unit.
:- type seconds           ---> seconds_unit.
:- type metres_per_second ---> metres_per_second_unit.
```

Mercury requires at least one constructor per type. These constructors are never called
— the type exists solely to be substituted for `Unit` in `quantity(Unit)`.

---

## Unit-safe arithmetic

Smart constructors create typed quantities; operations enforce unit correctness:

```mercury
:- func metres(float) = quantity(metres).
metres(X) = quantity(X).

:- func divide_speed(quantity(metres), quantity(seconds)) = quantity(metres_per_second).
divide_speed(quantity(D), quantity(T)) = quantity(D / T).
```

The compiler rejects unit mismatches at compile time — no runtime check needed:

```mercury
% TYPE ERROR — cannot add metres to seconds:
add_qty(metres(1.0), seconds(1.0))

% TYPE ERROR — argument order matters:
divide_speed(seconds(9.58), metres(100.0))
```

Both errors are caught before the program runs. The unit tags cost nothing at runtime.

---

## Compile-time state machines

Phantom types can encode *state* — legal transitions between states become type
signatures:

```mercury
:- type open   ---> open_state.
:- type closed ---> closed_state.

:- type file_handle(State) ---> file_handle(string).

:- func open_handle(file_handle(closed)) = file_handle(open).
:- func close_handle(file_handle(open))  = file_handle(closed).
:- func read_handle(file_handle(open))   = string.
```

Reading a closed handle is a *type error*, not a runtime exception:

```mercury
H0 = new_handle("test.txt"),           % file_handle(closed)
% read_handle(H0)                      % TYPE ERROR: expected open, got closed
H1 = open_handle(H0),                  % file_handle(open)
Contents = read_handle(H1),            % OK
H2 = close_handle(H1),                 % file_handle(closed)
% read_handle(H2)                      % TYPE ERROR: expected open, got closed
```

The state machine is total: every transition is explicit, every invalid transition is
rejected at compile time.

---

## What you will build

### `quantity(Unit)` with unit tags

Phantom type for physical quantities. Unit tags: `metres`, `seconds`,
`metres_per_second`, `kilograms`, `newtons`.

### Unit arithmetic

- `add_qty(quantity(U), quantity(U)) = quantity(U)` — same-unit addition
- `scale(float, quantity(U)) = quantity(U)` — scalar multiplication
- `divide_speed(quantity(metres), quantity(seconds)) = quantity(metres_per_second)`
- `force(quantity(kilograms), quantity(metres_per_second)) = quantity(newtons)`

### `file_handle(State)` state machine

States: `open`, `closed`. Operations: `new_handle`, `open_handle`, `close_handle`,
`read_handle`. Show in comments which calls would be type errors.

---

## Checkpoint

- `divide_speed(metres(100.0), seconds(9.58))` gives a speed > 10.0 m/s
- `add_qty(metres(50.0), metres(50.0))` gives `raw(...) = 100.0`
- `read_handle(open_handle(new_handle("f")))` compiles; `read_handle(new_handle("f"))` does not
- You can state: what makes a type parameter "phantom"?
- You can state: what does Mercury require of a phantom unit tag type?
