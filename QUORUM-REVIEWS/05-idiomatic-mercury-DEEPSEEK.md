# Review 05 — Idiomatic Mercury

**Reviewer:** DEEPSEEK
**Date:** 2026-06-22

## Score: 8/10

This review evaluates whether the code and exercises teach idiomatic Mercury — not just syntax that happens to compile, but the patterns, conventions, and design principles that experienced Mercury programmers use. I read ~50 solution files and analyzed them against Mercury best practices documented in the Mercury source distribution, the Mercury reference manual, and idiomatic patterns observed in the Mercury standard library.

## Context: What idiomatic Mercury means

Mercury is not Prolog, not Haskell, not ML. Idiomatic Mercury code reflects the language's unique design: explicit mode/determinism annotations, first-class DCG support, uniqueness typing, pure-by-default semantics with controlled impurity, and compile-time error checking for all of the above.

Key idiomatic markers:
1. **Explicit mode/determinism on every predicate** — not inferred, not optional
2. **Predicates as default, functions for expression nesting** — function for `det` single-output
3. **`!State` threading for IO and mutable state** — never hidden, always explicit
4. **`io.res`/`maybe`/custom errors for failure — not exceptions** — errors as values
5. **Cons-based list construction** — never `++` inside a loop
6. **DCG notation for parsing** — `-->`, not manual list threading
7. **`solutions/2` for nondet→det** — committed choice for first-solution
8. **`&` only over `det` goals** — compiler-enforced
9. **`promise_equivalent_clauses`/`promise_equivalent_solutions` with honesty** — document when it's a lie
10. **`use_module` with qualified calls for production code** — `import_module` for exercises

## Checklist: what the curriculum teaches vs what idiomatic Mercury is

### ✅ Explicit mode/determinism annotations (10/10)

Every predicate in the curriculum has explicit `:- mode` and determinism annotations. The curriculum never relies on inference. This is the single most important idiomatic Mercury practice, and the curriculum models it perfectly. The determinism and mode system tracks teach not just *that* you annotate, but *why* and *how to choose*.

Evidence: every kata solution file, every bridge starter, every puzzle solution. No exceptions found.

### ✅ Predicate-as-default (10/10)

The func-vs-pred kata (mode-system/09) explicitly teaches: "a function is a `det`, single-mode predicate whose result nests in expressions." The kata's rule — "predicate for anything that is not a total single-valued function" — is the exact rule idiomatic Mercury follows. The kata correctly teaches that `safe_div` must be a predicate (partial), `divides` must be a predicate (multi-solution), and multi-mode predicates have no function equivalent.

### ✅ `!State` threading (10/10)

Every IO predicate uses `!IO`. The `store` kata (advanced/08) extends this to `!S`. The STM kata (concurrency/09) teaches `!STM` as a separate context. The concurrent IO kata (concurrency/03) teaches that `thread.spawn` gives each thread its own IO token pair. The threading pattern is taught once in foundations (00-reactivation) and reinforced across every track.

### ✅ Error handling hierarchy (10/10)

Foundations 02 teaches `maybe(T)`. Foundations 07 teaches `io.res(T)` and `exception.catch_any`. Foundations 12 teaches `io.res` for file operations. Bridge 11 synthesizes all three into a comparison table with when-to-use guidance. The hierarchy (maybe → custom error ADT → io.res → exceptions for invariants only) is the exact pattern idiomatic Mercury follows. No other Mercury resource teaches this systematically.

### ✅ Cons-based list construction (9/10)

The puzzle 08 fix (quadratic `Acc ++ [Key - Val]` → `[Key - Val | Acc]` + `reverse`) is the standard Mercury idiom. The accumulator pattern is taught in the parsing track for left-recursion elimination (kata 05). `cord` is not taught, which is a gap — `cord` is the idiomatic choice for accumulating in reverse order when you want to avoid the `reverse` step.

### ✅ DCG notation (10/10)

The parsing track (9 katas) covers DCG basics through desugaring. All parsing exercises use `-->` notation rather than manual list threading. The DCG determinism kata (04) explains why multi-clause DCG rules infer `multi`/`nondet` and how if-then-else forces `semidet`. The desugaring kata (09) explains what `-->` compiles to. This is comprehensive idiomatic DCG teaching.

### ✅ `solutions/2` and committed choice (10/10)

The determinism track teaches `solutions/2` for collecting all solutions from a `nondet`/`multi` predicate, `cc_multi`/`cc_nondet` for committing to the first solution, `promise_equivalent_solutions` for the "all solutions are equivalent" claim, and if-then-else for implicit committed choice. This completes the idiomatic nondeterminism toolkit.

### ✅ `&` only over `det` (10/10)

Concurrency 01 teaches that `&` requires `det` or `cc_multi`. The kata includes a compile-error exercise (putting `semidet` in `&` and watching it fail). Bridge 04 reinforces this by wrapping `nondet` generators in `solutions/2` (making them `det`) before using `&`.

### ⚠️ `promise_equivalent_clauses` — taught but caution note needed (7/10)

Bridge 05 teaches `promise_equivalent_clauses` for multi-mode predicates. The bridge correctly warns: "the compiler takes your word for it." The bridge includes a "third mode trap" exercise that shows when the promise would be invalid. This is good. However, the bridge could be more explicit: *in production Mercury code, `promise_equivalent_clauses` is a last resort*. The idiomatic pattern is to write two separate predicates for different modes unless there's a compelling reason to unify them. The bridge mentions this implicitly ("keep the third mode out") but doesn't state the general principle.

### ⚠️ `use_module` vs `import_module` — inconsistent (6/10)

Most exercises use `import_module` with unqualified calls. This is fine for a teaching curriculum. But the advanced puzzle 08 (multi-module config) demonstrates `use_module` with qualified calls, and the abstract module kata (advanced/06) teaches the concept. A learner who sees only `import_module` in exercises may not realize that `use_module` is the production default. The foundations/01 kata covers the distinction but doesn't advocate for `use_module` as the production choice.

## Idiomatic patterns taught uniquely well

Several patterns are taught better in this curriculum than in any other Mercury resource:

| Pattern | Where | Why it's idiomatic |
|---|---|---|
| `failure` determinism for empty parsers | Combinator library puzzle | A parser that can never succeed should declare that fact |
| Inst aliases for parser state | Combinator library | Parametric insts for mode-checked combinators |
| `version_array` over `array` for shared reads | Bridge 05, mode-system 08 | `array` requires `di`/`uo` for every write; `version_array` is persistent |
| `busy_wait` TCO'd away in `asm_fast` | Bridge 10 | Real-world gotcha: busy-wait loops can be eliminated by tail-call optimization |
| 3 real `&` backend bugs in Mercury 22.01.8 | Concurrency 08 | Function calls in `&`, if-then-else after `&`, call ordering — documented with workarounds |
| GADT approximation strategies | Type-system 10 | Honest assessment of what Mercury cannot express and three workarounds |
| Combined sentinel + supervisor for threads | Bridge 10 | `maybe(T)` sentinel for end-of-stream + `maybe(string)` for crash detection |

## What's missing or underemphasized

### `cord` (gap)

Mercury's `cord(T)` provides O(1) amortized append. It's the idiomatic choice when you need to accumulate elements in order without committing to a list direction. The puzzle 08 fix uses `[Key - Val | Acc]` + `reverse` — the standard idiom — but never mentions `cord` as an alternative.

**Recommendation:** Add a one-paragraph "you could also use `cord`" note to foundations/11 (stdlib collections) or the parsing track.

### `list.foldl2`/`list.map_foldl` (underemphasized)

`list.foldl2` (threading two accumulators) and `list.map_foldl` (simultaneous map + fold) are standard Mercury idioms. They appear in bridges (02 uses `foldl2` in the starter) but are never taught as a standalone pattern. A learner who writes `list.foldl` with a tuple accumulator when `list.map_foldl` would be cleaner hasn't learned the idiomatic approach.

### `io.format` over string concatenation (underemphasized)

Most exercises use `io.write_string("Result: " ++ S ++ "\n", !IO)`. The idiomatic Mercury style is `io.format("Result: %s\n", [s(S)], !IO)`. The `io.format` version appears in some solution READMEs (bridge 03, bridge 08) but not consistently. The string-concatenation approach allocates intermediate strings; `io.format` does not.

**Impact:** Minimal for a teaching curriculum — beginners find string concatenation easier to read. But once the learner is comfortable, `io.format` is the production choice.

### `pragma memo` for semidet predicates (taught but subtle)

Advanced kata 04 teaches `pragma memo` for `det` predicates (fibonacci, Ackermann). The kata notes that `pragma memo` also works on `semidet` predicates — both success and failure are cached. This is correct but subtle: a `semidet` predicate whose failure is memoized will fail instantly on a second call with the same inputs that failed before. This can mask bugs where the predicate body has side effects (but a memoized predicate shouldn't have side effects anyway). The kata handles this correctly.

### `depend` pragma (not taught)

Mercury has `:- pragma depend([Var], Pred)` for declaring dependencies between state variables. This is used in some real-world Mercury code for optimizing uniqueness analysis. It's advanced and rarely needed — appropriate to exclude from a curriculum — but worth noting as a gap for completeness.

## Summary

| Idiom | Score | Status |
|---|---|---|
| Explicit mode/determinism | 10/10 | Universal |
| Predicate-as-default | 10/10 | Taught explicitly (func-vs-pred kata) |
| `!State` threading | 10/10 | Universal |
| Error handling hierarchy | 10/10 | Systematic across 3 katas + 1 bridge |
| Cons-based construction | 9/10 | Taught, but `cord` absent |
| DCG notation | 10/10 | 9 katas, comprehensive |
| `solutions/2` + committed choice | 10/10 | 3 katas + 1 bridge |
| `&` only over `det` | 10/10 | Taught with compile-error exercise |
| `promise_equivalent_clauses` caution | 7/10 | Taught but could be stronger |
| `use_module` vs `import_module` | 6/10 | Inconsistent across exercises |
| `list.foldl2`/`list.map_foldl` | 4/10 | Used but not taught |
| `io.format` over string concat | 4/10 | Used in some solution READMEs |
| Warning flags | 2/10 | Not covered |
| `cord` | 0/10 | Not mentioned |

**Overall idiomatic Mercury score: 8/10**

The curriculum nails the hard parts — mode/determinism annotations, state threading, error handling hierarchy, DCG usage, committed choice — that define idiomatic Mercury. These are the patterns that distinguish Mercury from Prolog and Haskell. The gaps (`cord`, `foldl2`, `io.format`, compiler warning flags, `use_module` emphasis) are real but peripheral — they affect production code quality but don't undermine the core idiomatic teaching. The fact that this curriculum teaches `failure` determinism for empty parsers, inst aliases for combinator libraries, and GADT approximation strategies puts it far ahead of any other Mercury resource in idiomatic depth.
