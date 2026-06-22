# Review 05 — Idiomatic Mercury

**Reviewer:** CODEX  
**Date:** 2026-06-22  
**Score:** 8.5/10 (static review)

## What the curriculum gets right

- It treats mode and determinism declarations as design tools, not decorative annotations. That is the central Mercury habit and is reinforced across the mode, determinism, parsing, and concurrency material.
- It makes state threading visible through `!IO`, `!STM`, and unique-state examples instead of hiding mutation behind an imperative abstraction.
- It uses DCGs as the default parsing notation while still teaching their desugaring and determinism consequences.
- It distinguishes ordinary failure, returned error values, exceptions, and committed choice. This is substantially more useful than presenting all failed operations as exceptions.
- It deliberately teaches `promise_equivalent_solutions` and `promise_equivalent_clauses` as promises with obligations, not as magic annotations for silencing the compiler.

## Findings and recommendations

### P3 — Add a collection-accumulation decision guide

The curriculum has examples of accumulator-plus-reverse and `foldl`, but no single place that tells a learner when to use a reversed list, `cord`, `map`, `set`, `assoc_list`, or an array/version array. Add this to the standard-library collections kata with complexity and ownership trade-offs. It would prevent both quadratic append habits and premature use of mutable structures.

### P3 — Make the `use_module`/`import_module` production trade-off explicit

The introductory examples correctly favor readability, and the module material covers the distinction. A concise advanced note should state the convention the project recommends for larger programs: when qualified calls and `use_module` improve dependency clarity, and when `import_module` is reasonable. Otherwise learners see both styles without a decision rule.

### P3 — Broaden higher-order state patterns

`foldl2` and map/fold patterns appear indirectly, but a named exercise or appendix on multi-accumulator folds, `map_foldl`, and state-variable alternatives would improve fluency. These are common ways real Mercury programs avoid ad hoc tuples and hand-written recursion.

## Caution on static evidence

The review did not label a promise pragma, FFI pragma, or concurrency construct incorrect based only on text search. Their validity depends on mode, determinism, foreign code, and grade-specific compilation; those require the unavailable toolchain verification described in Review 03.

## Verdict

The curriculum teaches the idioms that actually distinguish Mercury from Prolog and functional languages: explicit relations, modes, determinism, uniqueness, and compiler-checked concurrency. The improvements are about production-scale selection rules, not a missing conceptual foundation.
