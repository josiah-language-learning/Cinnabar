# Review 02 — Coverage

**Reviewer:** DEEPSEEK
**Date:** 2026-06-22

## Score: 8/10 breadth, 7.5/10 depth

I enumerated every exercise and assessed coverage against the full Mercury language surface: syntax, module system, type system, mode system, determinism system, standard library, FFI, tooling, concurrency, and advanced features. This review maps exactly which Mercury features are exercised, which are missing, and whether coverage depth is proportional to feature importance.

## Complete inventory

| Component | Count | `.m` files | READMEs | `.err` snapshots |
|---|---|---|---|---|
| Katas (8 tracks) | 71 exercises | 71 starter + ~71 solution/fixed | 71 + 8 track indexes | 0 |
| Koans | 80 | 71 (9 text-only) | 80 | 78 |
| Bridges | 12 | 12+ starters + helpers | 12 + 1 index + 12 solution | 0 |
| Puzzles | 21 | ~25 solution files | 21 + 1 index | 0 |
| **Total** | **184** | **~250 .m + ~80 solution** | **197** | **78** |

## Coverage by Mercury language feature

I mapped every exercise to specific Mercury concepts. The matrix below shows which concepts are covered and at what depth (K=kata, B=bridge, P=puzzle, KN=koan):

### Module system
| Feature | Coverage | Exercises |
|---|---|---|
| `:- module`, `:- interface`, `:- implementation` | K: foundations/01 | depth: 1 kata |
| `:- import_module` vs `:- use_module` | K: foundations/01, P: advanced/08 | 2 exercises, reasonable |
| `:- include_module` | **Not covered** | submodules are absent |
| `.int` → `.int2` → `.int3` interface pipeline | **Not covered** | no explanation of how Mercury compiles interfaces |
| `MAIN_MODULE` pragma | **Not covered** | multi-module project structure |
| `:- pragma foreign_export` | K: advanced/01 (mention) | mentioned but not drilled |

**Depth: minimal.** The module system is the weakest coverage area. For a project with 250+ `.m` files across 8 directories, the module system kata (foundations/01) teaches only the basics (interface/implementation split, import vs use). The `:- include_module` directive for submodules is absent. The interface file pipeline (`.int` → `.int2` → `.int3`) — which causes frequent confusion for new Mercury programmers — is never explained.

### Type system
| Feature | Coverage | Exercises |
|---|---|---|
| Discriminated unions (ADTs) | K: type-system/01 | 1 kata + ubiquitous in puzzles |
| Named-field ADTs | K: foundations/10 (record update) | all bridges use this |
| Parametric polymorphism | K: type-system/02 | 1 kata |
| Abstract types | K: type-system/03, P: advanced/08 | 2 exercises |
| Typeclasses: declaration, instances | K: type-system/04, 06, 07, B: 09 | 4 katas + 1 bridge — deep |
| Typeclass instance coherence | K: type-system/08 | 1 kata |
| Multi-parameter typeclasses, FDs | K: type-system/06 | 1 kata |
| Existential types | K: type-system/05 | 1 kata |
| Phantom types | K: type-system/09 | 1 kata |
| GADT approximation strategies | K: type-system/10 | 1 kata |
| `:- type_spec` pragma | **Not covered** | optimization pragma |

**Depth: excellent.** 10 dedicated katas covering every type system feature except `type_spec` (which is an optimization concern, not a teaching priority). The GADT approximation kata (10) is particularly thoughtful — Mercury has no GADTs, so the kata teaches three workaround strategies with honest trade-off documentation.

### Mode system
| Feature | Coverage | Exercises |
|---|---|---|
| Basic modes (`in`, `out`) | K: foundations/09 | precedes mode track |
| User-defined insts, `bound(...)` | K: mode-system/01 | 1 kata |
| Multi-mode predicates | K: mode-system/02, 05, B: 05 | 3 katas + 1 bridge — deep |
| Uniqueness (`di`, `uo`) | K: mode-system/03, 08 | 2 katas |
| Higher-order inst annotations | K: mode-system/04, B: 06, 12 | 2 katas + 2 bridges |
| Clause selection by calling mode | K: mode-system/07 | 1 kata |
| Inst hierarchy, parametric insts | K: mode-system/06 | 1 kata |
| `promise_equivalent_clauses` | K: mode-system/02, B: 05 | 2 katas + 1 bridge — deep |
| Function vs predicate (inst perspective) | K: mode-system/09 | 1 kata |

**Depth: excellent.** 9 dedicated katas + 2 bridges. The mode system track is the deepest public Mercury resource on modes. Uniqueness is covered in 2 katas (compared to 0 in any other Mercury tutorial). The func-vs-pred kata (09) is the most thorough treatment of the function/predicate distinction I've seen.

### Determinism system
| Feature | Coverage | Exercises |
|---|---|---|
| `det`, `semidet`, `multi`, `nondet` | K: determinism/01 | 1 kata |
| `erroneous`, `failure` | K: determinism/01 | 1 kata — unique to this curriculum |
| `cc_multi`, `cc_nondet` | K: determinism/02, 03 | 2 katas — unique to this curriculum |
| `promise_equivalent_solutions` | K: determinism/03, 07 | 2 katas — unique to this curriculum |
| Determinism in disjunctions | K: determinism/05 | 1 kata — unique to this curriculum |
| Determinism and negation | K: determinism/06 | 1 kata — unique to this curriculum |
| `require_complete_switch` | K: determinism/03 | 1 kata |
| Committed choice via if-then-else | K: determinism/02, 04, B: 04 | 3 katas + 1 bridge |
| `solutions/2` for nd→det conversion | K: determinism/01, 02, 04 | 3 katas + puzzles |

**Depth: excellent.** 7 dedicated katas + 1 bridge. This track covers determinism categories, committed choice, and compound determinisms (disjunctions, negation) — topics that exist in no other Mercury resource. The `erroneous` and `failure` determinisms are taught explicitly (the Mercury tutorial covers only `det`, `semidet`, `nondet`). The determinism lattice (kata 05) is the only published explanation of how Mercury combines determinisms across disjunction branches.

### Parsing / DCGs
| Feature | Coverage | Exercises |
|---|---|---|
| DCG syntax (`-->`) | K: parsing/01 | 1 kata |
| `{Goal}` semantic actions | K: parsing/02 | 1 kata |
| `parsing_utils` library | K: parsing/03, B: 07 | 1 kata + 1 bridge |
| DCG determinism (multi-clause = nondet) | K: parsing/04 | 1 kata |
| Left recursion and accumulator fix | K: parsing/05, B: 08 | 2 katas + 1 bridge — deep |
| Error recovery with parse results | K: parsing/06, B: 07 | 2 katas + 1 bridge |
| Stateful DCG (`!State` pattern) | K: parsing/07 | 1 kata |
| Packrat parsing via `pragma memo` | K: parsing/08 | 1 kata |
| DCG desugaring | K: parsing/09 | 1 kata |
| Pushback notation (`//3`) | K: parsing/09 (extension) | extension only |

**Depth: excellent.** 9 katas + 2 bridges. The progression from "what is `-->`" to "what `-->` compiles to" (kata 09, the desugarer) is well-designed. The packrat kata (08) is the only Mercury resource teaching memoized DCG parsing.

### Tooling
| Feature | Coverage | Exercises |
|---|---|---|
| Grades (compilation options) | K: tooling/01 | reference, no code |
| mdb (declarative debugger) | K: tooling/02 | 1 kata |
| Profiling (flat, deep) | K: tooling/03 | 1 kata |
| Tabling (`pragma memo`, `pragma loop_check`) | K: tooling/04 | 1 kata |
| Testing conventions (`check/2`) | K: tooling/05 | 1 kata |
| Property-based testing | K: tooling/06 | 1 kata |
| `--warn-unused-imports`, `--warn-known-bad-pred` | **Not covered** | warning flags missing |
| `mmc --make-short-interface` | **Not covered** | CI uses it, curriculum doesn't teach it |
| `.opt` files, intermodule optimization | **Not covered** | optimization pipeline |

**Depth: adequate.** 6 katas (1 reference). The property-based testing kata (06) is strong. The debugging kata (02) teaches mdb usage but doesn't ask the learner to *find* a bug — it's a guided tour, not a test. The lack of compiler warning flag coverage is a gap: `--warn-unused-imports` would catch a common beginner mistake (accumulating dead imports during development).

### Concurrency
| Feature | Coverage | Exercises |
|---|---|---|
| `&` parallel conjunction | K: concurrency/01, 08, B: 04 | 3 katas + 1 bridge |
| `thread.spawn`, `thread.channel` | K: concurrency/02, B: 10 | 2 katas + 1 bridge |
| Concurrent IO (separate IO tokens) | K: concurrency/03 | 1 kata |
| Granularity / spark overhead | K: concurrency/04 | 1 kata |
| Deadlock / semaphore mutex | K: concurrency/05 | 1 kata |
| `parallel_map` / `parallel_foldl` | K: concurrency/06 | 1 kata |
| Uniqueness at thread boundaries | K: concurrency/07 | 1 kata |
| Deterministic parallelism (`&` safety) | K: concurrency/08 | 1 kata |
| STM (`stm_builtin`) | K: concurrency/09 | 1 kata — unique |
| `io.mutvar` for shared state | K: concurrency/03 | 1 kata |

**Depth: excellent.** 9 katas + 1 bridge. The STM kata (09) is unique — no other Mercury resource teaches STM at all. The granularity kata (04) teaches *when not to parallelize*, which is pedagogically important. Kata 08 documents 3 real Mercury 22.01.8 `&` backend bugs with workarounds — extraordinary value.

### Advanced
| Feature | Coverage | Exercises |
|---|---|---|
| FFI pragmas (decl, type, proc, export) | K: advanced/01, 07 | 2 katas |
| Solver types / `any` inst | K: advanced/02 | reference, not buildable |
| RTTI / `deconstruct` | K: advanced/03 | 1 kata |
| `pragma memo` | K: advanced/04 | 1 kata |
| Association-list environments | K: advanced/05 | 1 kata |
| Abstract module design | K: advanced/06 | 1 kata |
| Mutable state via `store` | K: advanced/08, B: 12 | 1 kata + 1 bridge |
| Solver type mode errors | KN: advanced/07 | 1 koan |
| `promise_pure` / `impure` | K: foundations/00-reactivation/06, B: 12 | 2 exercises |
| `pragma foreign_export` | K: advanced/01 (mention) | mentioned not drilled |

**Depth: good.** 8 katas. The solver types kata is correctly documented as non-buildable (requires `.tr` grade). The FFI coverage spans 2 full katas. `pragma foreign_export` is mentioned but never exercised — important for C interoperability.

### Stdlib coverage

| Module | Exercises | Depth |
|---|---|---|
| `io` (file ops, format) | K: foundations/12, B: 11 | good |
| `list` (map, filter, foldl) | K: foundations/04, 05 | good |
| `map` | K: foundations/05 | good |
| `set` | K: foundations/06 | good |
| `maybe` | K: foundations/02, B: 01, 11 | good |
| `string` | K: foundations/03 | good |
| `int` (operations, ranges) | K: foundations/08 | adequate |
| `float` | K: foundations/08 | minimal (no dedicated kata) |
| `char` | parsing track | adequate |
| `array`, `version_array` | K: mode-system/03, 08; B: 05 | deep |
| `store` | K: advanced/08 | good |
| `cord` | **Not covered** | absent |
| `io.mutvar` | K: concurrency/03 | good |
| `bag`, `bimap` | K: foundations/11 (mentioned) | reference |
| `exception` | K: foundations/07 | good |
| `semaphore` | K: concurrency/05 | good |
| `time` | **Not covered** | minor gap |
| `random` | KN: foundations/15? | minimal |
| `maybe_error`, `maybe_util` | **Not covered** | useful utility |

**Gap:** `cord` is the most notable stdlib omission. Mercury's `cord(T)` provides O(1) amortized append — the idiomatic solution for accumulating in reverse order without `list.reverse`. The puzzle 08 `++` fix used `[Key - Val | Acc]` + `reverse`; `cord` would be the professional choice. A one-paragraph mention in foundations/11 (stdlib collections) or the parsing track would close this gap.

## Koan error-type coverage

The 80 koans (71 with `.m` files) target specific compiler error categories. I classified them:

| Error category | Koan count | Examples |
|---|---|---|
| Parser errors (syntax, module name) | ~8 | `koans/foundations/02-module-name`, `03-syntax-errors` |
| Type errors (inst mismatch) | ~12 | `koans/modes/00-inst`, `04-ho-inst-mismatch` |
| Determinism errors (det/semidet/nondet) | ~10 | `koans/determinism/00-det`, `01-det-mismatch`, `02-semidet-in-det` |
| Mode errors (uni, ground-not-unique) | ~8 | `koans/modes/05-ground-not-unique`, `06-inference-failure` |
| Typeclass errors (missing instance) | ~6 | `koans/type-system/05-missing-instance`, `06-missing-constraint` |
| Functional dependency errors | ~4 | `koans/type-system/07-superclass-instance` |
| Phantom type errors | ~2 | `koans/type-system/08-phantom-mismatch` |
| Existential type errors | ~3 | `koans/type-system/00-existential` |
| FFI/foreign errors | ~3 | `koans/advanced/00-ffi`, `01-ffi-mismatch` |
| Solver type errors (any inst) | ~2 | `koans/advanced/07-solver-any-inst` |
| Various foundations errors | ~15 | misc int ops, string, IO, etc. |
| Text-only (prerequisite) | 9 | `00-free-variable` (text), `01-ground` (text), etc. |

The koans cover the 80/20 of Mercury compiler errors. Missing categories: `--warn-unused-import` violations, module system errors (`.int` file not found), interface/implementation mismatch errors. These are less common but would complete the coverage.

## Complete coverage gaps (ordered by impact)

| Gap | Impact | Why it matters |
|---|---|---|
| Module system depth (submodules, `.int` pipeline) | High — affects all multi-file builds | Real Mercury projects use submodules and depend on interface files |
| `cord` | Medium — appears in many accumulation patterns | The idiomatic answer to "how do I append efficiently?" |
| `--warn-unused-imports` and warning flags | Medium — affects code quality | Beginners accumulate dead imports; the compiler warns but they don't know |
| No FFI bridge | Medium — real Mercury often needs C interop | Advanced kata 01 covers FFI syntax but no bridge exercises it |
| No debugging test | Medium — mdb is essential | Tooling kata 02 tours mdb but doesn't ask learner to find a bug |
| No mdb batch/script mode | Low — useful for automation | `mdb -s script` for unattended debugging |
| `pragma foreign_export` not drilled | Low — needed for C callbacks | Advanced kata 01 mentions it but doesn't exercise |
| No build/create multi-module project kata | Low — mmc --make module resolution | Project structure is learned by osmosis from bridges/puzzles |
| `pragma type_spec` | Low — optimization concern | Useful for type-specializing FFI wrappers |
| `immutable` pragma | Low — immutable data optimization | Niche optimization pragma |

**Impact assessment:** The module system gap is the most significant. A learner who completes the curriculum knows how to write individual `.m` files but may not understand how `mmc --make` resolves module names, what `.mh` files are, or how to structure a project with `:- include_module`. The bridges and puzzles demonstrate multi-module structure by example, but never explain the rules.

## Summary

| Track | Depth Score | Gaps |
|---|---|---|
| Foundations | 7/10 | No `cord`, no `foldl2` drill, module system shallow |
| Type system | 10/10 | None |
| Mode system | 10/10 | None |
| Determinism | 10/10 | None |
| Parsing | 10/10 | None (pushback is extension) |
| Tooling | 7/10 | No debug test, no warning flags, grades reference-only |
| Concurrency | 10/10 | None |
| Advanced | 7/10 | FFI mention not drilled, solver type non-buildable |
| Bridges | 9/10 | No FFI bridge, no module-system bridge |
| Puzzles | 9/10 | All 21 excellent |
| Koans | 9/10 | Missing module system/pragma warning errors |
| Stdlib | 7/10 | `cord`, `maybe_error`, `time` absent |
| Module system | 3/10 | Shallowest coverage |

**Overall coverage: 8/10**

The curriculum covers the hard, Mercury-specific topics (determinism lattice, mode hierarchy, uniqueness, STM, committed choice) with depth that exceeds any existing resource. The standard library coverage hits the 80/20 but misses `cord`. The module system is the weakest area — adequate for exercises but insufficient for independent project building. The 80 koans cover the most common compiler errors.
