# Koan: `use_module` in the interface — names not re-exported

**Broken concept:** using `use_module` in a module's interface section when
callers also need access to the imported module's names

## Prerequisites

- `katas/foundations/` — module system basics
- `katas/advanced/06-abstract-module` — `use_module` vs `import_module` in practice

---

**Text only — no broken `.m` file.** This koan is about the module system design
contract, not a single syntax error.

---

## The distinction

| In a module's interface | Effect on callers |
|---|---|
| `use_module foo` | Callers can use types from `foo` in signatures. Names from `foo` are NOT re-exported. Callers who also need `foo`'s names must add their own import. |
| `import_module foo` | Names from `foo` are re-exported to callers. Callers can use `foo` predicates without their own import. |

---

## The scenario

Module `geometry` has `use_module string` in its interface. A caller imports
`geometry` and tries to call `string.append`:

```mercury
:- module geometry.
:- interface.
:- use_module string.
:- pred label(float::in, float::in, string::out) is det.

:- implementation.
label(X, Y, L) :-
    string.format("(%f, %f)", [f(X), f(Y)], L).
```

```mercury
:- module viewer.
:- implementation.
:- import_module geometry.

:- pred show_label(float::in, float::in, io::di, io::uo) is det.
show_label(X, Y, !IO) :-
    geometry.label(X, Y, L),
    string.append(L, "!", L2),   % ERROR if viewer doesn't import string
    io.write_string(L2, !IO).
```

The viewer must add its own `import_module string` — `geometry`'s `use_module`
does not make `string` names available to `geometry`'s callers.

---

## When to use each

Use `use_module` in the interface when:
- You use a type from another module in your exported predicate signatures
- You do NOT want to force all callers to transitively get that module's names
- (Typical for implementation modules — keep imports explicit for callers)

Use `import_module` in the interface when:
- You are building a re-export or facade module
- Callers are expected to use the imported module's names directly

See `katas/advanced/06-abstract-module` for a concrete worked example where
`use_module` in the interface is the correct choice (opaque abstract type).

---

## What this teaches

Module imports in Mercury are NOT transitive by default. A caller who needs
`string` must import it themselves, even if the module they import already
imports `string` in its implementation. The interface section's `use_module` /
`import_module` choice controls what the interface re-exports, not what the
implementation uses internally.
