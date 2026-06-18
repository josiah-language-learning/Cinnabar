# 01 — Modules: the multi-module build

**Concept:** Mercury's module system — `:- interface`, `:- implementation`, `import_module`, `mmc --make`, Mmakefile basics

**What you will build:** a two-module temperature converter. `convert.m` exports `c_to_f` and `f_to_c` as functions. `main.m` imports it, reads a number and unit from command-line arguments, converts, and prints.

---

## Steps

### 1. Write `convert.m`

```
:- module convert.
:- interface.
    % export c_to_f and f_to_c here as funcs
:- implementation.
    % arithmetic here
```

The `:- interface` section declares what other modules can see. The `:- implementation` section is private. If a predicate or function is in `:- implementation` only, other modules cannot call it — the compiler enforces this.

### 2. Write `main.m`

```
:- module main.
:- import_module convert.
```

Read a float and a unit string from `io.command_line_arguments`. Call the appropriate conversion function from `convert`. Print the result with `io.format`.

Shape your argument parsing on the same pattern as `daytype.m` from the reactivation pass — `command_line_arguments` gives you a `list(string)`, pattern-match on it.

### 3. Build with `mmc --make`

```
mmc --make --grade asm_fast.par.gc.stseg main
```

`mmc --make` chases the `import_module convert` dependency automatically and compiles both modules. You do not need to list `convert.m` explicitly.

### 4. Write a minimal Mmakefile

```makefile
MAIN_TARGET = main
MERCURY_MODULES = main convert
include $(MERCURY_DIR)/Mmake.rules
```

Build with `mmake`. Confirm it produces the same binary as `mmc --make`.

### 5. Break it on purpose

Move one of `convert`'s helper functions (if you wrote any) from `:- interface` to `:- implementation` only. Try to call it from `main`. Read the compiler error. Move it back.

If you have no internal helpers, add a `double_celsius` function to `convert`'s `:- implementation` only, call it from `main`, read the error, then remove the call.

---

## Checkpoint

- `mmc --make main` builds clean from scratch
- `mmake` also builds it from the Mmakefile
- You can describe, in your own words, what the compiler error from step 5 said and why moving the function to `:- interface` would fix it

## `import_module` vs `use_module`

There is a subtle but important distinction:

- `import_module M` in a module's **interface** section makes `M`'s exported names available
  directly to all callers of your module — even ones that never explicitly import `M`. This is
  transitive export, and it is almost never what you want. It pollutes your callers' namespaces
  silently.

- `use_module M` in an **interface** section says "M's types appear in my exported signatures" but
  does not export M's names to callers. Callers who want M's predicates must import M themselves.

- `import_module M` in an **implementation** section is always fine — it affects only your
  module's internals.

Rule of thumb: use `use_module` in interface sections; use `import_module` in implementation sections.

## Interface files (`.int`, `.int2`, `.int3`)

When you run `mmc --make`, the compiler generates interface files into a `Mercury/` subdirectory.
These are what allow the compiler to type- and mode-check your module's callers without
recompiling your module from scratch each time. They contain a processed view of your interface
section.

Never edit interface files by hand — they are build artifacts. Add `Mercury/` to `.gitignore`.
If interface files get corrupted, delete the `Mercury/` directory and rebuild.

---

## What this unlocks

Every subsequent kata and every Mercury project larger than a single file uses the module system. The interface/implementation split — and the compiler's enforcement of it — is the foundation everything else sits on.

> **Tutorial cross-reference:** Mercury Tutorial §5 covers the module system basics. This kata
> extends that with the `import_module` vs `use_module` distinction and interface files, which
> the tutorial does not cover.
