# Review 05 — Idiomatic Mercury

**Reviewer:** BIG-PICKLE
**Date:** 2026-06-22

## Overall Assessment

This review evaluates whether the code and exercises teach idiomatic Mercury — the patterns, conventions, and design principles that experienced Mercury programmers use and that distinguish Mercury code from Prolog, Haskell, or ML code written in Mercury syntax.

---

## What Idiomatic Mercury Looks Like

Before assessing the project, I should establish the target:

1. **Predicates before functions** — the default is a predicate; functions are used when expression nesting is genuinely cleaner.
2. **Determinism annotations on every predicate** — not relying on inference.
3. **`di`/`uo` threading for unique state** — IO and store states are explicitly threaded, passed to every operation that needs them, never hidden.
4. **Named field access with `^`** — rather than `arg/3` or pattern matching for field access in records.
5. **`map` as the primary lookup abstraction** — rather than `association_list` for performance-sensitive paths.
6. **State threading with `!State` notation** rather than manual argument pairs.
7. **Higher-order predicates on containers** — `list.map`, `list.filter`, `list.foldl` rather than manual recursion for iteration.
8. **Committed choice for the first solution** — `cc_multi`/`cc_nondet` rather than `solutions/2` when you only need one answer.
9. **Error values, not exceptions** — `maybe(T)`, `io.res(T)`, and custom error ADTs for recoverable failures.
10. **`promise_equivalent_solutions` with care** — used only when the claim is true, documented when it's a lie.
11. **Pure state threading over `store`** — `list.foldl` before `store.new_mutvar`; `mutable` only as last resort.
12. **The sentinel pattern with `maybe(T)`** — `no` as "end of stream" rather than special integer values.

---

## What the Project Does Well

### 1. Determinism annotations are taught as design decisions

The determinism track systematically teaches that determinism is *the* signature property of a Mercury predicate, not an optional annotation. The six-categories kata teaches all six determinisms. The committed-choice kata teaches `cc_multi`/`cc_nondet` and `promise_equivalent_solutions`. The disjunction determinism kata teaches the lattice. This is the most comprehensive treatment of determinism in any Mercury resource.

Idiomatic Mercury: **10/10** — the project is the reference on this topic.

### 2. Mode annotations are explicit (never inferred)

Even in katas where the mode could be inferred (e.g., `:- pred main(io::di, io::uo) is det.`), the annotations are written out. This is the correct pedagogical choice — the curriculum teaches the mode system, so it must model explicit annotation.

Idiomatic Mercury: **10/10** — no shortcuts.

### 3. State threading with `!State` is demonstrated early

Foundations kata 00-reactivation's hello-world exercise introduces `!IO` threading. Every subsequent exercise that touches IO uses `!IO` threading. The `store` kata (advanced/08) extends the pattern to `!S` for private store state. The concurrency track teaches IO token splitting for threads (kata 03). The threading pattern is taught once and reinforced across the entire curriculum.

Idiomatic Mercury: **10/10** — no implicit state, no mutable globals taught as the first solution.

### 4. Error handling hierarchy is taught explicitly

Bridge 11 (error-handling) teaches the three-tier error model: `maybe(T)` for absence, custom error ADTs for recoverable failures, `io.res(T)` for OS errors, and exceptions for invariant violations. Foundations kata 12 (IO patterns) reinforces this with `io.res` for file operations. Foundations kata 02 teaches `maybe`.

This hierarchy is the most important idiomatic pattern in Mercury that differs from mainstream languages, and the project teaches it explicitly and repeatedly.

Idiomatic Mercury: **10/10** — this is the defining Mercury design pattern.

### 5. Func-vs-pred decision criteria are taught as a kata

Mode-system kata 09 (func-vs-pred) teaches the decision: function for `det` single-output expression nesting; predicate for everything else (partial relations, multi-output, multi-mode). The kata's key insight — "the determinism of the relation picks the shape for you" — is exactly the right framing.

Idiomatic Mercury: **10/10** — this kata distills a design principle that experienced Mercury programmers internalize but rarely articulate.

---

## What the Project Could Improve

### 1. `list.map`/`filter`/`foldl` are taught, but `list.foldl2`/`list.map_foldl` aren't drilled

Every exercise uses `list.foldl` for accumulation. But `list.foldl2` (threading two accumulators) and `list.map_foldl` (simultaneous map and fold) are standard Mercury idioms for combining iteration and accumulation. They appear in bridges (02 pipeline-extend uses `foldl2` in the starter, bridge 01 maybe-extend uses `foldl3`), but they're never taught as a standalone pattern.

**Why it matters:** A common mistake for new Mercury programmers is to thread state through `list.foldl` with a tuple accumulator when `list.map_foldl` would be cleaner. Teaching `list.foldl2` as a distinct pattern would prevent this.

**Fix:** Add a short note to foundations kata 04 (higher-order) or create a micro-exercise that contrasts `foldl` with `foldl2` for state + value collection.

### 2. `cord` is never mentioned

Mercury's `cord(T)` type (efficient append, O(1) amortized) is the idiomatic solution for the problem that puzzle 08's quadratic `++` was causing. The fixed code uses `[Key - Val | Acc]` + `list.reverse` — which is the correct fix — but never mentions `cord` as an alternative. For a curriculum that teaches idiomatic Mercury, `cord` should at least appear as a "you could also..." note.

**Fix:** Add a one-paragraph note to the parsing track or foundations stdlib-collections kata mentioning `cord.to_list` and `cord.list` for accumulating in reverse order.

### 3. `--warn-known-bad-pred` patterns not taught

Mercury's compiler has warnings for known bad patterns (accidental unification, missing switches). The `require_complete_switch` scope is taught in determinism kata 03, but the related `--warn-known-bad-pred` warnings (like using `\+` instead of `not` or `is` for comparison) aren't mentioned. The tooling track covers grades, mdb, profiling, and tabling but doesn't cover compiler warning flags.

**Fix:** Add a paragraph to tooling kata 01 (grades) about useful warning flags: `--warn-unused-imports`, `--warn-known-bad-pred`, `--warn-inst-var-without-constraint`.

### 4. `pragma foreign_export` is shown but not explained in context

The advanced FFI katas cover `foreign_proc` and `foreign_type`, but `foreign_export` — which is essential for Mercury libraries callable from C — is only mentioned in kata 01. For a curriculum that teaches FFI depth, the export direction matters as much as the import direction. The `initialize` pragma in foundations 00-reactivation 06 (pure-randomness) uses `foreign_proc` but doesn't discuss the export direction.

**Fix:** Add a note to advanced kata 01 or 07 about `foreign_export` and when you need it (callbacks, C API exposure). The meta-interpreter puzzle (advanced/06) could demonstrate this if extended.

### 5. `use_module` vs `import_module` is taught, but qualified calls aren't emphasized

Foundations kata 01 (modules) covers the import/use distinction, and the track index mentions it. But across the project, most files use `import_module` and unqualified calls. The abstract module kata (advanced/06) teaches `use_module` for information hiding, but intermediate files in puzzles and bridges don't always follow the `use_module` pattern when importing from other parts of the project.

**Why it matters:** `use_module` with qualified calls (`list.map(...)`) is the idiomatic Mercury style for non-trivial programs. `import_module` with unqualified calls is fine for exercises, but a learner who only sees `import_module` in the curriculum may not realize that `use_module` is the production default.

**Fix:** Use `use_module` with qualified calls in a few bridge solutions (01, 03) so learners see the qualified-call style in context. Add a note in foundations kata 01 or the module kata that `use_module` is preferred for production code.

### 6. `typeclass` vs `higher-order` — taught in kata 07, but the bridge doesn't reinforce it

Type-system kata 07 teaches when to use a typeclass vs. when to use a higher-order argument. But bridge 09 (typeclass-refactor) is about extracting an `int` evaluator into a typeclass-polymorphic one — it teaches typeclass *mechanics* but doesn't explicitly revisit the design question of "why typeclass, not higher-order?" The bridge could add a design-question section (as bridge 05 does for mode reversal) that asks: "Could you parameterize `eval` by passing the arithmetic operations as higher-order arguments instead of a typeclass? What does each approach lose?"

This would reinforce kata 07's lesson in a practical context.

---

## Minor Issues

### 1. `io.write_string` vs `io.format` usage

Most exercises use `io.write_string` with string concatenation: `io.write_string("Result: " ++ S ++ "\n", !IO)`. The idiomatic Mercury style is `io.format("Result: %s\n", [s(S)], !IO)` — no intermediate string allocation, and the format string is a single pass. The `io.format` version appears in some solution READMEs (bridge 03, bridge 08) but not consistently.

**Impact:** Minimal. `++` on short strings is fine. The consistent use of `io.write_string` is actually easier for beginners to read. This is a "once you're comfortable, try `io.format`" note rather than a bug.

### 2. `solutions/2` vs `sorted_solutions/2`

When katas collect solutions, they use `solutions/2`. The `sorted_solutions/2` variant returns solutions in a sorted order (using `compare/3` on the output type). For exercises where order matters (determinism kata 02's `all_colorings_parallel` which compares against sequential results), `sorted_solutions/2` would make the comparison order-independent. The current approach works because `solutions/2` returns solutions in depth-first order, which is deterministic, but this is an implementation detail.

**Impact:** Very minor. The kata's correctness doesn't depend on this, but mentioning `sorted_solutions/2` as an alternative would be a nice touch.

---

## Summary

| Dimension | Score (1-10) |
|-----------|-------------|
| Determinism as design | 10 |
| Mode annotation explicitness | 10 |
| State threading | 10 |
| Error handling hierarchy | 10 |
| Func vs pred decision | 10 |
| `list.foldl2`/`map_foldl` taught | 4 |
| `cord` mentioned | 0 |
| Compiler warning flags taught | 2 |
| `use_module` vs `import_module` | 6 |
| `typeclass` vs `higher-order` reinforced | 5 |

**Overall idiomatic Mercury score: 8/10**

The project nails the hard parts — determinism, modes, state threading, error handling — that are the actual barriers to writing idiomatic Mercury. The gaps are in the "nice to have" category: `cord`, `foldl2`, `io.format`, compiler warning flags. These are easy to add and would make the curriculum more complete, but they don't undermine the core idiomatic Mercury teaching. The project's approach of teaching design principles (determinism picks the shape) rather than just syntax is what makes it idiomatic.
