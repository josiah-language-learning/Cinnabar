# Review 02 — Coverage

**Reviewer:** BIG-PICKLE
**Date:** 2026-06-22

## Overall Assessment

The project covers an unusually broad span of Mercury and logic-programming topics — 184 exercises across 8 kata tracks, 12 bridges, 21 puzzles, and 80 koans. The coverage spans from `hello-world` module skeleton to multi-module config libraries, from `det` to solver types, from `mmc --make` to property-based testing.

Coverage is the project's strongest dimension by raw breadth. The question is: what's missing, and what is over- or under-weighted?

---

## Track-by-Track Coverage

### Foundations (12 katas + 00-reactivation's 7 micro-exercises)

Covers: modules, maybe, string, higher-order, map, set, exceptions, built-in types, mode inference, record update, stdlib collections, IO patterns, plus 7 "reactivation" exercises.

**Gaps:**
- No kata on `maybe` chaining with `bind_maybe` as a distinct skill (it appears in bridge 01 and bridge 11 but is never drilled as a standalone kata). The concept is important enough — it's the monadic pattern in Mercury — that a focused kata would be valuable.
- No kata on `list` operations beyond `map`/`filter`/`foldl`. `list.foldl2`, `list.map_foldl`, `list.take_while`, `list.split_while` are all patterns that appear in bridges and puzzles but aren't drilled.
- IO patterns (12) is strong, but it doesn't cover `io.read_file_as_string` or `io.write_file` — the convenience wrappers that real code uses instead of manual loops.

### Type System (10 katas)

Covers: discriminated unions, parametric polymorphism, abstract types, typeclasses, existential types, typeclass depth (superclasses, MPTCs, FDs), typeclass design (typeclass vs higher-order), instance coherence, phantom types, GADT approximation.

**This is the most complete track.** Every major Mercury type system feature is here. The GADT kata (10) is particularly notable because Mercury doesn't have native GADTs — the kata teaches *approximation* strategies, which is the correct pedagogical choice.

**Gap:** No kata on `--type-pragmas` or `pragma type_spec` for specializing polymorphic code. This is an optimization concern, but it's a real-world issue when wrapping C libraries.

### Mode System (9 katas)

Covers: insts and modes, multi-mode, uniqueness deep, higher-order insts, mode-specific clauses, inst hierarchy, clause selection, array threading, func-vs-pred.

**Strong coverage.** The uniqueness track (03) and array threading (08) are topics that exist in no other Mercury tutorial. The func-vs-pred kata (09) is the best-written explanation of the function/predicate distinction I've seen in Mercury materials.

**Gap:** No kata on parametric insts beyond the introduction in kata 01. The `inst_hierarchy` kata (06) covers user-defined `bound(...)` insts and parametric insts but doesn't have a dedicated parametric-inst drill. The concept appears in practice in bridge 02 (pipeline-extend) but isn't isolated.

### Determinism (7 katas)

Covers: six categories, committed choice, scope annotations, multi/nondet, determinism in disjunctions, determinism and negation, `promise_equivalent_solutions`.

**Complete.** This is the only determinism-specific resource in the Mercury ecosystem. The standard Mercury tutorial covers only `det`/`semidet`/`nondet`; this track adds `multi`, `erroneous`, `failure`, `cc_multi`/`cc_nondet`, and `promise_equivalent_solutions`. The negation kata (06) is particularly important because `\+`'s variable-binding semantics are a common source of confusion for new Mercury programmers.

### Parsing (9 katas)

Covers: DCG basics, DCG goals, parsing_utils, DCG determinism, left-recursion, error recovery, stateful DCG, packrat, DCG desugaring.

**Complete and well-sequenced.** The progression from "what `-->` means" to "what `-->` compiles to" is the right arc. The error recovery kata (06) is an important bridge between "parsing with DCGs is fun" and "real parsers need error messages."

### Tooling (6 katas)

Covers: grades, mdb debugging, profiling, tabling, testing, property-based testing.

**Gap:** The grades kata is reference-only (no code). This is acceptable — grades are an encyclopedic topic — but it means the tooling track has only 5 code exercises. The lack of a working build system kata (how to structure multi-module projects with `mmc --make`, what `.mh` files are, how `MAIN_MODULE` works) is notable given that puzzles and bridges routinely use multi-module setups.

### Concurrency (9 katas)

Covers: parallel conjunction, threads, concurrent IO, granularity, deadlock, parallel map-fold, uniqueness and threads, deterministic parallelism, STM.

**Very strong.** The STM kata (09) is a genuinely rare topic — no other Mercury tutorial covers STM. The granularity kata (04) is pedagogically important: teaching *when not to parallelize* is as important as teaching how to do it. The deadlock kata (05) is well-structured with semaphore-based mutex and resource-ordering exercises.

### Advanced (8 katas)

Covers: FFI depth, solver types, RTTI, pragma memo, assoc-list env, abstract modules, FFI pragma attributes, mutable state.

**Gap-heavy but understandably so.** Solver types (02) have a `.tr` grade dependency and are documented as non-working. This is fine for a reference kata. The FFI coverage is strong (two dedicated katas + pragma attributes). The mutable state kata (08) is well-written.

**Missing topics:** `pragma foreign_export` (covered in kata 01 but not drilled), `pragma foreign_decl` vs `pragma foreign_code`, the FFI's C types, `unsafe_promise_unique` (should not be taught, but should be mentioned as an escape hatch). The abstract module kata (06) is good but could be paired with a "plugin architecture" exercise that demonstrates `use_module` vs `import_module` in practice (this is partly covered by the advanced puzzle `07-plugin-architecture`).

---

### Bridge Coverage (12 exercises)

Covers: maybe-extend (config reader), pipeline-extend, DCG-extend (tokenizer), determinism-ratchet, mode-reversal, pipeline-parameterization, parser-hardening, expression-language, typeclass-refactor, parallel-pipeline, error-handling, currying-and-impurity.

**Excellent selection.** Each bridge targets a specific conceptual threshold: determinism-ratchet demonstrates the `nondet` → `det` boundary via `solutions/2` and how parallel conjunction cuts through it; mode-reversal makes multi-mode design concrete; currying-and-impurity pairs partial application with mutable impurity in a way that shows the friction between them.

**Gap:** No bridge between determinism and the decision-theoretic/planning concepts that the "polyparadigm" promise implies. The curriculum is described as "polyparadigm" but all bridges teach Mercury/declarative idioms. A bridge that contrasts Mercury's solution with a Prolog or Haskell approach to the same problem would earn the "polyparadigm" label.

### Puzzle Coverage (21 puzzles)

Covers: sudoku, N-queens, crypto-arithmetic, anagram finder, expression evaluator, graph reachability, frequency histogram, calculator, CSV reader, config parser, parallel sort, producer-consumer, parallel pipeline with unique state, generic printer, memoized search, bidirectional search, combinator library, generic parser, plugin architecture, Mercury meta-interpreter, multi-module config.

**This is the deepest puzzle library for Mercury in existence.** The meta-interpreter (advanced/06) is an extraordinary exercise — implementing a Mercury meta-interpreter in Mercury makes advanced type system and mode system concepts concrete. The multi-module config puzzle (advanced/08) is the one that had the quadratic `++` bug that was already fixed.

### Koan Coverage (80 koans)

Covers: 80 compiler error messages, each with a *diagnostic snapshot (`.err` file) that `ci.sh` verifies.

**This is the project's most innovative feature.** No other Mercury resource maps specific compiler error messages to minimal failing programs. The coverage spans: parser errors (syntax, module name mismatch), type errors (inst mismatch, HO inst mismatch, existential, typeclass, phantom), determinism errors (nondet in det context, commit choice misuse), mode errors (unique mode, ground-not-unique), and more.

The koan strategy works because Mercury's error messages are unusually specific (they include the inst that was expected vs. the inst that was found). A learner who works through these 80 koans will recognize most Mercury compiler errors on sight.

---

## What's Missing

### 1. No "Why Polyparadigm" synthesis

The curriculum is called "polyparadigm-project" but never explicitly teaches *paradigm comparison*. All 184 exercises teach Mercury declarative programming; none ask "how would you do this in Python/JS/Haskell?" and then contrast the approach. This is a deliberate scope choice (the project is pre-alpha and focused on Mercury first), but the name sets an expectation that isn't yet met.

**Suggestion:** Add a "Paradigm Note" callout box to 5-10 key exercises (mode reversal, determinism ratchet, uniqueness, STM, impure mutables) that briefly compares how another language handles the same problem.

### 2. No build-system kata

A kata on Mercury's module system (foundations/01) covers `import_module` vs `use_module`, but there's no drill on multi-file project structure, `mmc --make` module resolution, or interface files (`.mh`). Bridges and puzzles routinely use multi-module setups; the learner has to pick up the build patterns by osmosis.

### 3. No "pure vs impure" kata beyond the bridge

Bridge 12 (currying-and-impurity) covers `impure`/`semipure` and `promise_pure`, but this is a bridge — the learner is extending working code. A kata that drills the distinction from scratch (when to use `mutable` vs `store` vs a pure accumulator) would reinforce the design principle that appears throughout the curriculum.

### 4. Standard library gaps

The foundations track covers `map`, `set`, and `maybe`, but not:
- `cord` (efficient append — the right answer to the quadratic `++` bug in puzzle 08)
- `list.foldl2` vs `list.map_foldl` (different threading patterns)
- `string.format` vs `io.format` (pure vs impure)
- `time` module (not essential but useful for profiling exercises)

These are minor gaps; the curriculum already covers the 80/20 of Mercury's stdlib.

---

## Summary

| Dimension | Score (1-10) |
|-----------|-------------|
| Foundational concepts | 9 |
| Type system depth | 10 |
| Mode system depth | 9 |
| Determinism depth | 10 |
| Parsing / DCG depth | 10 |
| Concurrency depth | 10 |
| Advanced topics | 8 |
| Bridges (applied exercises) | 9 |
| Puzzles (open-ended) | 10 |
| Koans (error messages) | 10 |
| Paradigm comparison | 1 |
| Build system / tooling | 5 |

**Overall coverage score: 9/10**

The curriculum covers topics that exist in no other Mercury resource (determinism lattice, STM, mode-specific clause selection, 80-error koan library). The gaps — paradigm comparison, build system kata, pure/impure kata — are minor relative to the scope. Coverage is unquestionably the project's strongest dimension, and with 184 exercises already written, it's not thin coverage at any point.
