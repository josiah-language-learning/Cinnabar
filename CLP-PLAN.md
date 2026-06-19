# CLP Integration Plan

Mercury has a formal hook for Constraint Logic Programming (`solver type`, `any` inst,
trailing grade) but no bundled CLP engine and no maintained third-party CLP library for
Mercury 22. This document records what needs to happen at each stage.

---

## Background

Mercury's CLP machinery has three layers:

1. **Type-system hook** — `solver type` declaration tells the mode checker to treat a
   type's variables as potentially `any` (constrained but not fully determined). The
   compiler enforces `any`-vs-`ground` distinctions statically. This layer works today
   with no external library.

2. **Trailing grade** — the runtime's `undo` mechanism. When a branch fails, the
   runtime walks a trail of constraint-store modifications and reverses them. Without
   trailing, `solver type` variables cannot backtrack correctly. Grade: `asm_fast.gc.tr`.
   This grade is not currently built in mise.

3. **Constraint engine** — the actual propagation logic (domain narrowing, arc
   consistency, labeling). Mercury's stdlib provides only the primitive hooks in
   `solver_builtin.m` (`solver_type_init`, `copy_store_backtrack_barrier`, etc.).
   No working CLP(FD) engine exists for Mercury 22. This is the missing piece.

---

## Phase 1 — Near-term (no engine required)

### 1a. Add grades to mise

File: `mise/languages/mercury/compilers/22.01.8.nix`

Add two grades to `--enable-libgrades`:

- `asm_fast.gc.stseg` — non-parallel sequential grade. Needed for `pragma memo` in
  non-parallel contexts (packrat parsing, `advanced/04-pragma-memo`). Also useful as a
  simpler build target when parallelism is not needed.
- `asm_fast.gc.tr` — trailing grade. Required for any code that uses `solver type` and
  needs correct backtracking into the constraint store.

The `configureFlags` line becomes:

```nix
configureFlags = "--enable-deep-profiler=$out/lib/mercury/cgi-bin \
  --with-default-grade=asm_fast.par.gc.stseg \
  --enable-libgrades=asm_fast.par.gc.stseg,asm_fast.gc.debug.stseg,asm_fast.gc.stseg,asm_fast.gc.tr";
```

**Note:** Adding grades significantly increases Mercury build time. Expect the mise
rebuild to take 20-40 minutes per new grade on a typical machine.

### 1b. Update `katas/advanced/02-solver-types`

Currently a reference kata with pseudocode. Expand to:

- Honest statement of the CLP engine situation for Mercury 22 (no maintained library)
- Working `solver type` declaration that Mercury 22 accepts
- Mode declaration examples using `any` inst
- The specific error Mercury gives when you try to use `.tr`-only features without the
  trailing grade
- What WILL be possible when Phase 2 is complete (point to this file)
- Pointers: `library/solver_builtin.m` in Mercury source, Mercury reference manual
  §9.6 (solver types), SWI-Prolog CLP(FD) as a conceptual reference

### 1c. Add `koans/advanced/07-solver-any-inst`

A koan that shows the mode checker enforcing `any` vs `ground` without needing an
actual constraint engine. The koan:

1. Declares a minimal solver type
2. Declares predicates with `any`-mode arguments
3. Shows the compile error when calling those predicates from a `ground` context without
   the `any` inst annotation

This gives learners something concrete to compile and read without needing Phase 2 to
be complete. Teaches: `any` is NOT `free` — it is a distinct inst for values that are
constrained but not yet determined.

---

## Phase 2 — Long-term: Rust CLP engine

### What to build

A finite-domain (FD) constraint propagation engine in Rust, exposed via Mercury's FFI
as a proper `solver type` backend. Target functionality:

- **Domain constraints**: `domain(Var, Low, High)` — set an integer domain
- **Arithmetic constraints**: `#=`, `#\=`, `#<`, `#=<`, `#>`, `#>=`
- **Global constraints**: `all_different(Vars)` (alldiff)
- **Labeling**: `labeling(Vars)` — enumerate solutions by instantiating variables

Benchmark problems once working: SEND+MORE=MONEY, N-Queens via CLP.

### Mercury FFI interface

```mercury
:- solver type clp_fd_var
    where
        representation is int,
        ground         is ground,
        any            is any,
        constraint_store is clp_store.

:- pragma foreign_type("C", clp_store, "ClpStore *").

:- pragma foreign_proc("C",
    clp_domain(Var::in(any), Low::in, High::in),
    [will_not_call_mercury, thread_safe],
    "clp_set_domain(Var, Low, High);").
```

The Rust crate exposes a C ABI (`cbindgen` can generate headers automatically). Mercury
links it as a `foreign_decl`/`foreign_proc` FFI library.

### Trailing integration

Mercury's trailing API (from `runtime/mercury_trail.h`):

- `MR_trail_value(ref, value)` — save a value to the trail so it can be restored on
  backtrack
- `MR_trail_function(func, data)` — schedule an arbitrary undo function

The Rust engine's constraint store modifications must call into Mercury's trail so that
backtracking correctly undoes them. This is the trickiest integration point — the engine
and the Mercury runtime must share the trail.

The grade `asm_fast.gc.tr` must be used for any program that runs this engine.

### Rust crate structure

```
mercury-clpfd/
  src/
    lib.rs          — C-ABI exports (unsafe extern "C" fn)
    store.rs        — constraint store: domains, constraints, trail events
    propagate.rs    — arc consistency (AC-3 algorithm)
    label.rs        — labeling / enumeration
  cbindgen.toml     — generates mercury_clpfd.h for Mercury's foreign_decl
  Cargo.toml
```

### Milestone sequence

1. Build `mercury-clpfd` crate with domain + `#=` + `all_different` + `labeling`
2. Wire Mercury trailing: confirm SEND+MORE=MONEY solves correctly with backtracking
3. Wrap in a Mercury module `clpfd.m` with a clean interface
4. Write a cinnabar kata: full CLP(FD) kata replacing the reference kata
5. Write SEND+MORE=MONEY and N-Queens as advanced puzzles using CLP

---

## Open questions

- **Rust + Boehm GC interaction**: the Mercury runtime uses the Boehm GC. The Rust
  engine's heap-allocated data must either be invisible to GC (stack-only or raw C
  pointers via `unsafe`) or registered as GC roots. Safest: store constraint data
  entirely in C-compatible structs managed by Rust's allocator, returned to Mercury as
  opaque pointers. Mercury's GC does not scan those pointers if they are stored in the
  trail/store, not in Mercury heap terms.

- **Thread safety**: cinnabar's default grade is parallel (`asm_fast.par.gc.stseg`).
  The trailing grade is `asm_fast.gc.tr` (sequential). CLP work will need the sequential
  trailing grade; the parallel grade is incompatible with trailing in Mercury 22.

- **Build integration**: cinnabar's `flake.nix` pulls from mise. Once Phase 1a adds
  `asm_fast.gc.tr` to mise, cinnabar can add a second `devShell` targeting the trailing
  grade for CLP-specific katas.
