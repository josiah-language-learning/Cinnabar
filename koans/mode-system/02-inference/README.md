# Koan: variable used before it can be bound

**Broken concept:** a variable that is read in an expression before any goal in the clause
can produce it — a case where mode inference cannot help

## Prerequisites

- `katas/foundations/09-mode-inference` — goal reordering, when inference fails
- `katas/mode-system/02-multi-mode` — multiple mode declarations for one predicate

---

Mercury's mode checker reorders goals to satisfy data dependencies. But some orderings
are impossible: if a variable is needed inside an if-then-else condition, and the only
producer of that variable is inside the then-branch, there is no valid reordering.

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg inference_koan
```

The compiler reports a mode error: variable `Threshold` has instantiation state `free`
at the point where it is used in the condition.

---

## What to observe

The `classify` predicate uses `Threshold` in an if-then-else condition. The only place
`Threshold` gets a value is inside the then-branch of the same if-then-else. There is
no topological order of goals that can make this work.

---

## Your task

Restructure the predicate so `Threshold` is bound before the if-then-else uses it.
