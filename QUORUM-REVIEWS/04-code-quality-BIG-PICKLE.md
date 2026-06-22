# Review 04 — Code Quality

**Reviewer:** BIG-PICKLE
**Date:** 2026-06-22

## Overall Assessment

This review evaluates the Mercury code in starters, solutions, and koans for readability, concision, idiomatic construct use, and adherence to `mmc`-enforced best practices. The review is based on static analysis of representative `.m` files across all tracks.

Mercury's compiler is itself a code-quality tool: it checks mode correctness, determinism correctness, type safety, and exhaustiveness. So the baseline quality is high — the compiler rejects many classes of bugs that would be runtime errors in other languages. The review focuses on what the compiler does *not* enforce: naming, structure, comments, and design patterns.

---

## Strengths

### 1. Consistent predicate/function naming

Across all tracks, predicates use `snake_case` and types use `CamelCase`, following Mercury convention. Predicate names are descriptive: `read_lines`, `load_users`, `group_by_category`, `token_to_string`. No cryptic abbreviations (`rd_lns`, `grp_cat`).

### 2. Mode annotations are explicit (not inferred)

Every starter and solution file explicitly declares modes and determinisms. For a project that teaches the mode and determinism system, this is essential — relying on inference would undermine the pedagogical goal. The `func-vs-pred` kata (mode-system/09) is a particularly clean example:

```mercury
:- func area(float, float) = float.
:- mode area(in, in) = out is det.

:- pred safe_div(int::in, int::in, int::out) is semidet.

:- func checked_div(int, int) = maybe(int).
:- mode checked_div(in, in) = out is det.
```

### 3. Type definitions use named fields consistently

When a type has more than one field, the project uses named-field ADTs (with `^` access) rather than positional access:

```mercury
:- type config --->
    config(
        host :: maybe(string),
        port :: maybe(int)
    ).
```

This is the right call — named fields scale better for exercises that ask learners to add fields (every bridge extension does this).

### 4. Import lists are explicit, not `*`

Every `.m` file uses explicit `:- import_module list, map, maybe.` rather than `:- import_module *`. This is good practice — it makes dependencies visible and avoids accidental name collisions.

### 5. Koan `.m` files are minimal (one error each)

Each koan is a single .m file (mostly one predicate) that triggers exactly one compiler error. The error is commented in the `.err` snapshot. This minimality is pedagogically correct — the learner should not have to guess which line caused the error.

---

## Issues

### 1. Comment density varies dramatically

Some solution files are thoroughly commented (every non-trivial predicate has a doc comment and inline explanation), while others are almost bare. Examples:

- **Bridge 04 (determinism-ratchet) solution/README.md**: well-commented, explains why `solutions/2` is needed, why `&` works, what the determinism boundary is.
- **Bridge 03 (dcg-extend) starter**: IIRC spartan comments.

For a *curriculum*, consistency matters more than volume. A learner who opens two bridges and finds one densely commented and one nearly bare will wonder which style they should imitate.

**Fix:** Adopt a minimum-comment standard: every exported predicate gets a one-line doc comment. Inline comments for non-obvious algorithm steps (why the `float_tok` rule must come before `int_tok`, why the sentinel pattern needs two `no`s in bridge 10).

### 2. No use of `--warn-unused-imports` or `--infer-all` in CI

The CI script (`ci-bak.sh`) compiles with grade flags but doesn't enable optional warnings:
- `--warn-unused-imports` would catch import drift as files evolve (a common problem in growing codebases).
- `--infer-all` would verify that all explicitly declared modes/determinisms match inference (a useful correctness check, though it can be noisy in multi-module projects).

**Suggestion:** Add `--warn-unused-imports` to the `compile_pass` invocations (lines 87 and elsewhere). It's non-fatal by default but CI could check for warning-free output.

### 3. The `pipeline` module name collision (documented)

As noted in the correctness review, `bridge/02-pipeline-extend/pipeline.m` and `bridge/10-parallel-pipeline/pipeline.m` both define `:- module pipeline`. This is not a bug (they're in separate build directories), but it's a quality concern: a learner who accidentally runs `mmc --make pipeline` in the wrong directory may get unexpected results. The `ci-bak.sh` build process builds each file from its own directory, but the `.gitignore` lists `pipeline` as a binary, meaning only one can exist at the root.

**Fix:** Consider renaming one to `pipeline_extend` and `pipeline_parallel`, or keeping them in their bridge directories (which they already are). The module declaration `:- module pipeline.` is the source; a learner might forget to rename when reusing the code.

### 4. `parsing_utils` import usage is inconsistent

Bridge 07 (parser-hardening) uses DCG rules with explicit state threading. Bridge 03 (dcg-extend) uses `parsing_utils` for whitespace handling. The `parsing_utils` module is part of Mercury's standard library but is not consistently imported across parsing-related katas and bridges. The kata track index says `03-parsing-utils` covers it, but I didn't see a consistent `:- import_module parsing_utils.` across all parsing exercises.

**Verification needed:** Check which parsing exercises import `parsing_utils` and whether the import is consistent with what the README promises.

### 5. Stale `.swp` files in working tree

The repository has 3 stale `.swp` files (Vim swap files). These are from the author's editing sessions and should be cleaned up. The `.gitignore` already excludes `*.swp`, `*.swo`, `.*.swp`, and `.*.swo`, so they won't be committed, but they clutter the working tree.

**Fix:** `find . -name '*.swp' -delete` or add to a pre-existing cleanup script.

### 6. `.aider.chat.history.md` at repository root (6.6MB)

This file is gitignored (`.aider/` is listed in `.gitignore`) but physically present at root. At 6.6MB it's a large text artifact from AI-assisted development. While harmless (it won't be committed), it's untracked noise.

**Suggestion:** Add `.aider.chat.history.md` explicitly to `.gitignore` (it's currently covered by the broader `.aider/` rule, but the file sits at root, not in `.aider/`). Confirm it's not tracked: `git check-ignore .aider.chat.history.md`.

---

## Patterns Worth Preserving

### The `func`-first argument ordering

Bridges 02, 06, and 12 use config-first argument ordering for transforms:

```mercury
:- func scale(float, float) = float.   % scale(Factor, Value) = Result
```

This enables partial application: `scale(2.0)` is a callable `func(float) = float`. This is consistently done across all bridges and is the right convention.

### The `start.m` + `solution/` pattern

Every kata has `start.m` (starter with stubs) and `solution/fixed.m` (complete solution). Every bridge has starter `.m` files and `solution/README.md` with annotated solution code. Every puzzle has `solution/` directory. This structure is consistent and makes the three-tier difficulty clear: starter alone, starter extended, solution provided.

### The `mmc --make` build command in every README

The build instructions are in the README, not in a build script. This is the right call for a curriculum — learners should learn to run `mmc --make` themselves, not rely on a Makefile to abstract it away.

---

## Summary

| Dimension | Score (1-10) |
|-----------|-------------|
| Naming conventions | 9 |
| Comment consistency | 5 |
| Module structure | 8 |
| Import hygiene | 7 |
| Build hygiene | 7 |
| Working tree cleanliness | 5 |
| Idiomatic construct use | 9 |

**Overall code quality score: 7/10**

The code is structurally sound (Mercury's compiler enforces most important properties), and the project's naming and organizational conventions are consistent. The main issues are comment density variance (which affects learnability), the stale `.swp` files and `.aider.chat.history.md` noise, and the missing compiler warning flags in CI. These are all fixable in an hour or two of focused cleanup.
