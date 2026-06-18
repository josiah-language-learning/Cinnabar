# Koan: higher-order pred stored without inst, then called

**Broken concept:** storing a predicate in a data structure without an inst annotation,
then trying to call it — the mode checker cannot verify the call is safe

## Prerequisites

- `katas/mode-system/04-higher-order-insts` — higher-order inst syntax, storing preds in data structures
- `koans/foundations/03-higher-order` — the simpler version of this inst error

---

This is the same underlying issue as `koans/foundations/03-higher-order`, but at a deeper
level: the pred is stored in a `map` and retrieved, which loses even more inst information.

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg ho_inst_koan
```

The mode error will occur at the `call/2` site: the predicate retrieved from the map
has inst `ground` (or some non-callable inst), not `pred(in, out) is det`.

---

## What to observe

Retrieving a value from a `map` gives you something of the value type, with no inst
information beyond `ground`. Even if you stored a callable predicate, the type system
only records the type — the inst of the retrieved value is `ground`, which is not a
callable inst for higher-order predicates.

---

## Your task

Fix the code so that higher-order predicates stored in the map are callable when retrieved.
The solution uses a wrapper type with the inst information encoded in the wrapper.
