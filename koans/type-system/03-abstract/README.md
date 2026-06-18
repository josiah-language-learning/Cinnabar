# Koan: pattern-matching on an abstract type constructor

**Broken concept:** a client module trying to pattern-match on the internal constructor
of an abstract type

## Prerequisites

- `katas/type-system/03-abstract-types` — abstract type declarations, exported operations vs exposed constructors

---

When a type is declared as `:- type counter.` in a module's interface (without showing
its constructors), clients can only use the operations exported by that module. They cannot
pattern-match on the underlying representation.

---

## Two files in this koan

- `stack.m` — defines an abstract `stack(T)` type with `push`, `pop`, `empty`, `is_empty`
- `stack_client.m` — tries to pattern-match on the internal `stack_node` constructor

Build `stack_client`:
```
mmc --make --grade asm_fast.par.gc.stseg stack_client
```

The error names the constructor that is not visible: something like "constructor
`stack_node/2` not defined in module `stack`" or "not in the current scope."

---

## Your task

Fix `stack_client.m` to use only the public interface (`stack.pop`, `stack.is_empty`, etc.).
Do not modify `stack.m` — the abstraction is intentional.
