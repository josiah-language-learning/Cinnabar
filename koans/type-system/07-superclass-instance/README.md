# Koan: subclass instance without superclass instance

**Broken concept:** declaring an instance for a subclass typeclass (`describable`)
without first declaring an instance for its superclass (`printable`) — Mercury requires
all superclass instances to exist before a subclass instance is accepted

## Prerequisites

- `katas/type-system/03-typeclasses` — typeclass declarations and instances
- `koans/type-system/05-missing-instance` — unsatisfiable typeclass constraints

---

Mercury's typeclass hierarchy is enforced at instance declaration time. If typeclass `B`
has superclass `A` (written `typeclass B(T) <= A(T)`), then declaring
`instance B(shape)` is only valid if `instance A(shape)` also exists. The compiler
checks this at the point of the subclass instance declaration, not at use sites.

---

## Try it

```
mmc --make superclass_koan
```

The compiler reports that a superclass constraint is not satisfied for the `describable`
instance — specifically that `printable(shape)` is missing.

---

## What to observe

`describable` requires `printable` as a superclass. The code declares
`instance describable(shape)` but never declares `instance printable(shape)`.
Mercury rejects this because any code that uses `describable` can also assume
`printable` — the superclass guarantee must be concretely backed.

---

## Your task

Add an `instance printable(shape)` declaration before the `describable` instance.
The `do_print` method needs an IO action: delegate to a module-level predicate
rather than inlining a multi-goal body (the comma inside `where [...]` is an
item separator, not goal conjunction).
