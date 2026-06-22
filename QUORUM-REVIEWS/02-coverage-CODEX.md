# Review 02 — Coverage Breadth and Depth

**Reviewer:** CODEX  
**Date:** 2026-06-22  
**Score:** 8/10

## Inventory

The tree contains 71 kata starters, 77 kata `runtests` scripts (the difference is the nested reactivation exercises), 12 bridges, 21 puzzles, and a large koan corpus with both intentionally failing source and compiling solutions. Coverage is substantial across foundations, types, modes, determinism, parsing, tooling, concurrency, and advanced topics.

## Strong coverage

- Modes and determinism receive the depth Mercury learners actually need: insts, multi-mode relations, uniqueness, committed choice, disjunction, negation, `cc_*`, and promise pragmas.
- Parsing is a real progression, not a token DCG example: grammar basics, semantic goals, determinism, left recursion, recovery, stateful parsing, memoization, and desugaring are all represented.
- The curriculum includes the awkward but important material many introductions omit: error diagnostics, concurrency, STM, FFI attributes, abstract modules, solver types, and mutable state.
- The format ladder supplies different kinds of practice. Koans isolate diagnosis, katas build mechanics, bridges reduce blank-page friction, and puzzles require synthesis.

## Gaps and risks

### P2 — Module/package-scale development is thin relative to the rest of the curriculum

There are useful module and abstract-type exercises, but little sustained practice in organizing a multi-module application: interface versus implementation boundaries, submodules, dependency direction, build targets, and refactoring across a package. The advanced multi-module config puzzle is valuable, but it arrives late and is solution-led rather than a scaffolded sequence.

Add a short bridge after foundations/modules or abstract modules: split a small program into public interface, implementation, test module, and executable; then deliberately break an interface contract and diagnose the resulting compiler error.

### P3 — Production workflow coverage is fragmented

Grades, mdb, profiling, tabling, and testing are individually present. What is missing is an end-to-end maintenance exercise where a learner profiles a slow program, chooses a grade, writes a regression test, changes an implementation, and interprets a compiler/runtime result. This is the point where isolated tooling facts become engineering practice.

### P3 — Data-oriented standard-library practice could be more explicit

Maps, sets, assoc lists, arrays, and version arrays appear, but practical selection criteria are scattered. A comparative exercise covering `list`, `map`, `set`, `assoc_list`, `array`, `version_array`, and `cord` would teach representation choice and cost models, rather than leaving learners to infer them from distant examples.

### P3 — Cross-track retrieval is missing

The track sequence provides prerequisites, but there is little deliberate revisiting. Add small mixed review prompts at each track boundary: for example, a parser task that requires a mode choice and a structured error type. This provides retention and reveals whether a concept transfers outside its original chapter.

## Non-findings

The claim that most katas lack automated checks is not supported by the current tree: every kata starter is paired with a `runtests` script, and the reactivation sub-exercises account for additional scripts. Test quality still merits execution-based review, but script presence is not the coverage gap.

## Verdict

Breadth is exceptional for a self-directed Mercury curriculum and the difficult language-specific topics are well represented. The next gain is not more isolated concepts; it is package-scale work, comparative standard-library judgment, and cross-track synthesis.
