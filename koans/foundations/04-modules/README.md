# Koan: `import_module` in an interface section

**Broken concept:** using `import_module` rather than `use_module` in a module's
interface section

## Prerequisites

- `katas/foundations/01-modules` — `import_module` vs `use_module`, interface and implementation sections

---

When you write `import_module M` in a `:- interface` section, you are making M's
exported names transitively available to all clients of your module — even clients
that never explicitly import M. This is almost never what you want.

The correct choice for interface sections is `use_module`, which makes M's *types*
available for use in your interface signatures without re-exporting M's predicates
to your callers.

---

## What to observe

This koan has two files: `utils.m` (the leaky module) and `client.m` (which imports
`utils`). Build `client`:

```
mmc --make --grade asm_fast.par.gc.stseg client
```

It builds. Now notice: `client.m` uses predicates from `string` even though it never
imports `string`. This works because `utils.m`'s `import_module string` in its
interface section re-exports `string`'s names to all callers.

This is the bug: the re-export is accidental. If `utils.m` later changes to not use
`string` in its interface, `client.m` silently breaks.

---

## Your task

Fix `utils.m` to use `use_module string` in the interface section. Observe what
breaks in `client.m`. Then fix `client.m` to explicitly import what it needs.
