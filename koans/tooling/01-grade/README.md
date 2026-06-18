# Koan: invoking `mdb` without the debug grade

## Prerequisites

- `katas/tooling/01-grades` — grade anatomy, grade modifiers reference
- `katas/tooling/02-debugging-mdb` — `mdb` 4-port tracing

---

**Text only — no broken `.m` file.** This koan is about the build+run process, not
the source code.

---

## The scenario

You have a Mercury program that has a bug you want to debug with `mdb`. You build it
with the default grade and try to run it under `mdb`:

```bash
mmc --make --grade asm_fast.par.gc.stseg my_program
mdb ./my_program
```

`mdb` exits immediately with a message like:
```
mdb: this program was not compiled with debugging enabled.
```

or the binary runs normally, ignoring the `mdb` invocation.

---

## What went wrong

`mdb` requires the program to be compiled with a debug-enabled grade. The `.debug`
modifier must appear in the grade string. `asm_fast.par.gc.stseg` does not include it.

---

## The fix

Recompile with the debug grade:

```bash
mmc --make --grade asm_fast.gc.debug.stseg my_program
mdb ./my_program
```

The debug grade instruments the binary with Mercury's 4-port tracing infrastructure.
Without it, `mdb` cannot attach.

---

## Grade/feature dependency table

| What you want to do | Required grade component |
|---------------------|-------------------------|
| `mdb` debugging | `.debug` |
| `&` parallel conjunction | `.par` |
| `thread.spawn` | `.par` |
| `pragma memo` tabling | C backend (no extra modifier) |
| Flat profiling | `.prof` |
| Deep profiling | `.profdeep` |
| Solver types / CLP | `.tr` |

See `katas/tooling/01-grades/README.md` for the full reference.

---

## What this teaches

Grade mismatches are the #1 "why does mdb not work" question for Mercury beginners.
The fix is always the same: match your grade to the feature you need. The cost is a
debug-grade build is significantly slower and larger than a production-grade build —
keep separate build targets for development and release.
