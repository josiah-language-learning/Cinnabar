# 01 — Mercury grades: a reference guide

**No code.** This is a reference document. Read it before doing `02-debugging-mdb`,
`03-profiling`, or `04-tabling` — each requires a specific grade.

---

## Grade anatomy

A Mercury grade is a string that describes how the program will be compiled and what
runtime features will be available. Format:

```
<base>.<modifier1>.<modifier2>...
```

### Base backends

| Base | Description |
|------|-------------|
| `asm_fast` | Native code via GCC, fastest execution |
| `hlc` | High-level C (portable, compatible with more systems) |
| `java` | Java bytecode backend |
| `csharp` | C# / .NET backend |

`asm_fast` is the standard backend for this project. It produces fast native binaries
via C as an intermediate, using the GCC calling convention for speed. `hlc` is portable
but slower; you will not need it in this environment.

### Common modifiers

| Modifier | What it enables | Notes |
|----------|-----------------|-------|
| `.gc` | Boehm garbage collector | Almost always present |
| `.debug` | `mdb` debugger support | Needed for `02-debugging-mdb` |
| `.par` | Parallel conjunction (`&`), threads | Needed for concurrency katas |
| `.prof` | Flat profiling (gprof-compatible) | Needed for `03-profiling` (flat) |
| `.profdeep` | Deep profiling (Mercury-specific) | More accurate than `.prof` |
| `.tr` | Trailing (for solver types / CLP) | Needed for `02-solver-types` |
| `.mm` | Minimal model tabling | Advanced tabling |
| `.stseg` | Stack-segment optimization | Avoids fixed-size stack limits |
| `.pregen` | Pre-generated interface files | Historical portability workaround; not used here |

Modifier ordering within a grade string follows Mercury convention: `.par` comes before
`.gc`, and `.gc` before `.debug`/`.prof`/`.profdeep`. The `.stseg` modifier comes last.
Example: `asm_fast.par.gc.stseg`, `asm_fast.gc.debug.stseg`.

### Feature/grade dependency table

| Feature | Required grade component |
|---------|-------------------------|
| `mdb` debugger | `.debug` |
| `&` parallel conjunction | `.par` |
| `thread.spawn` | `.par` |
| `pragma memo` tabling | C backend (no extra modifier) |
| `pragma loop_check` | C backend (no extra modifier) |
| Minimal-model tabling | `.mm` |
| Solver types / CLP | `.tr` |
| Flat profiling | `.prof` |
| Deep profiling | `.profdeep` |

### Grade mismatch errors

If you compile a library with one grade and try to link against it from another grade,
you get a link error like:
```
error: grade mismatch: library was compiled with grade X, caller requires grade Y
```

The fix: compile everything with the same grade. If you switch grades, delete the
`Mercury/` build directory first — stale interface files from the old grade will
cause link failures even after recompilation.

### Available grades in this environment

The cinnabar dev shell (via `flake.nix`) provides two compiled grades:

| Grade | Use |
|-------|-----|
| `asm_fast.par.gc.stseg` | All standard katas and concurrency katas |
| `asm_fast.gc.debug.stseg` | `mdb` debugging (`02-debugging-mdb`) |

Profiling grades (`asm_fast.gc.prof.stseg`, `asm_fast.gc.profdeep.stseg`) are not
compiled into the default shell. If you need them, see your Mercury installation's
`GRADE` file or rebuild with additional `--enable-libgrades` entries.

### When to use which grade

| Situation | Grade |
|-----------|-------|
| Development / testing / concurrency | `asm_fast.par.gc.stseg` |
| Debugging with `mdb` | `asm_fast.gc.debug.stseg` |
| Flat profiling | `asm_fast.gc.prof.stseg` |
| Deep profiling | `asm_fast.gc.profdeep.stseg` |
| Tabling (`pragma memo`) | `asm_fast.par.gc.stseg` (C backend, no extra modifier needed) |
| Solver types / CLP | `asm_fast.gc.tr.stseg` |

---

## Quick reference

```bash
# Build with explicit grade (standard)
mmc --make --grade asm_fast.par.gc.stseg main

# Build for debugging
mmc --make --grade asm_fast.gc.debug.stseg main

# Build for deep profiling
mmc --make --grade asm_fast.gc.profdeep.stseg main

# Clean stale build artifacts before switching grades
rm -rf Mercury/
```
