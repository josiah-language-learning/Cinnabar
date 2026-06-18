# 03 — Set: flags model

**Concept:** `set(T)` — insert, delete, membership test, threaded state with `!`, `foldl` over a command list

**What you will build:** a tiny flags model over `set(string)` — `set_flag`, `clear_flag`, and `has_flag` as threaded predicates — driven by a hardcoded list of commands via `foldl`.

---

## Steps

### 1. Write `flags.m`

Define the predicates:

```mercury
:- pred set_flag(string::in, set(string)::in, set(string)::out) is det.
:- pred clear_flag(string::in, set(string)::in, set(string)::out) is det.
:- pred has_flag(string::in, set(string)::in) is semidet.
```

`set_flag` inserts the string into the set. `clear_flag` removes it. `has_flag` succeeds if it is present, fails otherwise.

### 2. Define a command ADT

```mercury
:- type flag_cmd
    --->    turn_on(string)
    ;       turn_off(string)
    ;       check(string).
```

Write a predicate `apply_cmd(Cmd, !Flags, !IO)` that applies the command to the flag set, printing a line on `check`.

### 3. Drive it with `foldl`

Hardcode a list of `flag_cmd` values in `main`. Fold it over an initial `set.init`, threading both the flag set and `!IO`.

---

## `set` reference

Verify exact signatures in the [Mercury Library Reference](https://mercurylang.org/information/doc-latest/mercury_library/set.html):

| Predicate | Determinism | Notes |
|---|---|---|
| `set.init` | `det` | empty set |
| `set.insert(!Set, Elem)` | `det` | no-op if already present |
| `set.delete(!Set, Elem)` | `det` | no-op if absent |
| `set.contains(Set, Elem)` | `semidet` | membership check |
| `set.member(Elem, Set)` | check modes in docs | may support `(out, in) is nondet` to enumerate |

Check whether `set.member` has a `(out, in) is nondet` mode — that is, whether you can use it to enumerate the set's elements as well as to test membership. If so, this is the same generate-vs-test duality from the zookeeper puzzle, now appearing in the standard library.

---

## Checkpoint

- A command sequence of `[turn_on("a"), turn_on("b"), check("a"), turn_off("a"), check("a"), check("b")]` prints the right lines (present / absent / present)
- You can say out loud: this `set_flag`/`clear_flag`/`has_flag` triple is not an analogy for a rule system's effects and conditions — it *is* the shape of those operations, in miniature
- If you checked `set.member`'s modes: one sentence on what you found

## The shape to carry forward

The `(string::in, set(string)::in, set(string)::out) is det` signature of `set_flag` and `clear_flag` is the exact shape of a threaded state operation: take a state in, produce a state out, deterministically. When Stage 1 of a Mercury project threads a custom game state the way `!IO` threads I/O, you will write predicates with this same signature — just replace `set(string)` with your state type.
