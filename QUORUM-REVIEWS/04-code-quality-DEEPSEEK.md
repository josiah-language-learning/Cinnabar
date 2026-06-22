# Review 04 — Code Quality

**Reviewer:** DEEPSEEK
**Date:** 2026-06-22

## Score: 8/10

I read ~50 solution `.m` files across all exercise types — bridges, puzzles, katas, and koans — plus starter files and README code blocks. The codebase is uniformly well-structured with consistent conventions. Puzzle solutions are the strongest code in the project; koan code is deliberately minimal and broken in precisely one way per file.

## Consistency of conventions

| Convention | Adherence | Notes |
|---|---|---|
| 4-space indentation | 100% | No tabs, no mixed styles across all files checked |
| Explicit `:- mode` annotations | 100% | Every predicate in solutions has explicit mode dec + determinism |
| Explicit determinism | 100% | Every predicate has `is det`, `is semidet`, etc. |
| `:- pred` vs `:- func` choice | Correct where used | Function only used for `det` single-output; predicates for everything else |
| Named-field ADTs with `^` | Bridges, puzzles, advanced katas | Positional ADTs used only in simple types (1-2 constructors) |
| `!State` notation for state threading | All IO predicates | `!IO`, `!S`, `!STM` threaded correctly |
| `module`, `interface`, `implementation` | 100% | Correct Mercury module structure |
| Explicit `:- import_module` | 100% | No star imports, explicit module lists |
| Comments on non-obvious logic | 60% | Bridges well-commented; katas vary |

## Sample files reviewed (with detailed notes)

### Bridge solution READMEs (the best educational code)

| File | Lines | Quality | Key observations |
|---|---|---|---|
| `bridge/04-determinism-ratchet/solution/README.md` | ~95 | Excellent | Shows 3 approaches: `solutions/2` + `list.head`, `find_first_match`, `cc_multi` via committed choice. Compares trade-offs. Includes `&` parallelization note. |
| `bridge/05-mode-reversal/solution/README.md` | 109 | Excellent | Mode reversal with `promise_equivalent_clauses`. Explains third-mode trap. `version_array` vs `array` trade-off. Design questions at end are pedagogically valuable. |
| `bridge/08-expression-language/solution/README.md` | 149 | Excellent | Accumulator pattern for left-associativity. `parse_result` error type design. Tokenizer → Parser → Evaluator pipeline structure. |
| `bridge/10-parallel-pipeline/solution/README.md` | 255 | Excellent | Fan-in sentinel fix (two workers = two sentinels). Supervisor restart pattern. Doc on `busy_wait` being TCO'd away in `asm_fast` grade. Scale-down for signal-based concurrency. |
| `bridge/11-error-handling/solution/README.md` | 218 | Excellent | Import note (stdlib module organization). Comparison table: `maybe` vs custom errors vs `io.res` vs exceptions. When-to-use guidance. |
| `bridge/12-currying-and-impurity/solution/README.md` | ~180 | Excellent | Two solution approaches (quarantine with `promise_pure` vs pure accumulator). Compares at end. |

### Puzzle solutions (the strongest production code)

| File | Lines | Quality | Key observations |
|---|---|---|---|
| `puzzles/logic/01-sudoku/solution/sudoku.m` | 155 | Excellent | Imports list, type definition, `nondet` backtracking with `int.nondet_int_in_range`. Clean helper decomposition. |
| `puzzles/concurrent/01-parallel-sort/solution/parallel_sort.m` | 114 | Excellent | `split_at` with `det` safety check (length mismatch). `&` with threshold for granularity. Amdahl's Law reference. |
| `puzzles/advanced/04-combinator-library/solution/combinators.m` | 183 | Excellent | Inst aliases for parser state. `failure` determinism for empty parser (correct and idiomatic). Sequence combinators. |
| `puzzles/advanced/07-mercury-in-mercury/solution/` | 187 line README | Excellent | Variable freshness analysis with compiler verification. Type-safety note: Meta-interpreter is well-typed by construction. |

### Kata solutions (consistent, minimal)

Kata starter files are intentionally minimal (often just module + type declarations). Solution files follow a consistent pattern: fill the stub, add imports, implement predicates. The uniformity is by design — kata = focused single-concept repetition.

### Koan code (deliberately broken)

Koans are 25-60 line files that produce exactly one compiler error. Examples:

| Koan | Lines | Error type | Code quality notes |
|---|---|---|---|
| `koans/foundations/01-maybe/maybe_koan.m` | 25 | Func/pred mismatch | Minimal file, one wrong declaration, clear BUG comment |
| `koans/determinism/01-det-mismatch/det_koan.m` | 22 | Determinism mismatch | Missing else branch, produces specific error |
| `koans/type-system/05-missing-instance/inst_koan.m` | ~40 | Missing typeclass instance | Correctly positioned error — instance deliberately omitted |

Each koan has a `BUG` comment marking the error point. The `.err` snapshot captures the expected compiler output. This is good pedagogical design: the error is explicit, the snapshot documents what the learner should see.

## Specific code pattern analysis

### Bridge 06 — Record of functions (intentional failure)

Bridge 06 Task 3 asks the learner to try storing functions in a record:

```mercury
:- type pipeline --->
    pipeline(
        filter    :: pred(item::in) is semidet,
        transform :: func(item) = float
    ).
```

The README correctly notes: "Mercury does not allow inst-annotated types in record field declarations." The learner is told to expect failure and choose a workaround. This is the right approach — teaching the limitation by having the learner hit it, not by lecturing about it.

### Combinator library — `failure` determinism

The combinator library puzzle defines an `empty` parser with determinism `failure`. This is correct: an empty parser can never succeed, so its determinism reflects that. The solution README explains why `failure` (not `semidet` that always fails) is the right choice — it communicates intent to the compiler. This is advanced idiomatic Mercury.

### Multi-module config puzzle — Abstract types

The multi-module config puzzle (advanced/08) uses abstract types and opaque constructors across module boundaries. This is the best demonstration of `:- use_module` vs `:- import_module` in the project. The code correctly uses `use_module` with qualified calls for non-interface modules.

### Concurrent IO kata — `io.mutvar` + semaphore

The concurrent IO kata (03) uses `io.mutvar` for shared state with a semaphore mutex. The code is clean: mutex acquisition, read-modify-write, release. The kata doesn't use `atomic` operations — correct, because Mercury doesn't have them; the semaphore mutex is the idiomatic pattern.

## Issues found

### 1. `allow` keyword usage inconsistency

Some code uses `allow` as a variable name (e.g., `puzzles/parsing/01-calculator/solution/`). In Mercury, `allow` is not a keyword, but it looks like it should be. This is a minor naming concern — `Allowed` or `Allow` would be clearer.

### 2. NO `--warn-unused-imports` in CI

The CI script (`ci-bak.sh`) compiles with grade flags but doesn't enable optional warnings. `--warn-unused-imports` would catch a common code-quality issue: imports that accumulate during development and are never removed. For a teaching curriculum, having clean imports is important — the learner should see only the imports needed for their code.

### 3. Bridge solution README code blocks do not include `import_module` consistently

The CI's bridge snippet syntax checker (lines 232-331 of `ci-bak.sh`) works around this by auto-injecting standard imports (`io, int, string, list, maybe, char, bool, exception, require, float`). The solution README code blocks intentionally omit imports for brevity. This is fine for the CI but means a learner who copies code directly from a solution README might see errors from missing imports. The solution READMEs could add a note: "Code blocks below omit `import_module` declarations; add them as needed."

### 4. `mmc --make-short-interface` limitation

The CI uses `mmc --make-short-interface` for bridge snippet syntax checking (line 317 of `ci-bak.sh`). The script's own comment (lines 314-316) acknowledges: "these blocks are fragments... they cannot be fully type-checked in isolation." The workaround (parsing only declaration well-formedness) is correct but weak — a syntax error would be caught, but a type error (wrong number of arguments to a predicate defined in the bridge starter) would not. This is an honest limitation of the Mercury toolchain.

### 5. `.swp` files and `.aider.chat.history.md`

Three stale `.swp` files in the working tree (Vim swap files). The `.gitignore` excludes `*.swp`, so they won't be committed, but they clutter the tree.

`.aider.chat.history.md` (6.6MB) at repository root. Gitignored by the `.aider/` pattern (line 164) and the file-specific entry (line 165). Not tracked, but a large artifact.

## Most idiomatic code patterns observed

| Pattern | Where | Why it's idiomatic |
|---|---|---|
| `[H | T]` cons for accumulation | Puzzle 08 (after fix) | O(n) list building, not O(n²) `++` |
| `failure` determinism for `empty` parser | Combinator library | "this parser can never succeed" as typed contract |
| `solutions/2` for nondet→det | Determinism track | Standard collector for multi-solution predicates |
| `promise_equivalent_solutions` with scope | Determinism 03, 07 | "all solutions are equivalent" — compiler trusts, programmer verifies |
| `io.res(T)` for file operations | Foundations 12, bridge 11 | Errors as values, not exceptions |
| `list.foldl` with `!Acc` for state | Every kata | Standard state threading pattern |
| `&` with threshold for granularity | Concurrency 04 | Don't parallelize tiny work units |
| `version_array` over `array` for shared reads | Bridge 05, mode-system 08 | Persistent (no unique mode needed for reads) |
| `use_module` with qualified calls | Advanced puzzle 08 | Information hiding across module boundaries |
| `promise_pure` for quarantined impurity | Bridge 12 | Acknowledge impurity, limit scope |

## Summary

| Sub-dimension | Score (1-10) | Notes |
|---|---|---|
| Naming conventions | 9 | Consistent snake_case preds, CamelCase types |
| Indentation/style consistency | 10 | 4-space everywhere, no mixed styles |
| Comment/documentation density | 6 | Bridges well-commented; katas spartan |
| Module/file structure | 9 | All files have correct Mercury module structure |
| Import hygiene | 8 | Explicit imports, no star imports |
| Use of idiomatic constructs | 8 | Good patterns throughout; `cord` not taught |
| Binary/solution naming | 9 | `start.m` + `solution/fixed.m` everywhere |
| Koan minimality | 10 | Each broken in exactly one way, BUG comments |
| CI toolchain quality | 7 | Well-structured script; disabled; no warning flags |
| Repository cleanliness | 6 | `.swp` files, `.aider.chat.history.md` noise |

**Overall code quality score: 8/10**

The codebase is structurally sound, consistently formatted, and uses correct Mercury idioms. The puzzle solutions are production-quality. The main code-quality concerns are (a) inconsistent comment density (bridges are well-commented, katas are spartan), (b) disabled CI with no warning flags, and (c) minor repository noise. These are all fixable without architectural changes.
