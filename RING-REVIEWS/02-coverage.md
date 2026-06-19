
# aider chat started at 2026-06-19 19:14:16

> /home/josiah/.local/bin/aider --no-git --chat-mode ask --model openrouter/inclusionai/ring-2.6-1t --map-tokens 1000 --yes --no-auto-commits --read README.md --read katas/README.md --read katas/foundations/README.md --read katas/type-system/README.md --read katas/mode-system/README.md --read katas/determinism/README.md --read katas/parsing/README.md --read katas/tooling/README.md --read katas/concurrency/README.md --read katas/advanced/README.md --read katas/concurrency/09-stm/README.md --read katas/determinism/07-promise-equiv-solutions/README.md --read katas/advanced/02-solver-types/README.md --read katas/tooling/06-property-testing/README.md --read bridge/11-error-handling/README.md --read koans/advanced/07-solver-any-inst/README.md --read CLP-PLAN.md --message-file /tmp/ring-r2-prompt.txt --chat-history-file /home/josiah/Development/personal/education/self/polyparadigm-project/cinnabar/RING-REVIEWS/02-coverage.md  
> Aider v0.86.2  
> Model: openrouter/inclusionai/ring-2.6-1t with ask edit format  
> Git repo: none  
> Repo-map: disabled  
> Added katas/mode-system/README.md to the chat (read-only).  
> Added katas/concurrency/README.md to the chat (read-only).  
> Added katas/parsing/README.md to the chat (read-only).  
> Added katas/advanced/README.md to the chat (read-only).  
> Added bridge/11-error-handling/README.md to the chat (read-only).  
> Added katas/tooling/README.md to the chat (read-only).  
> Added CLP-PLAN.md to the chat (read-only).  
> Added README.md to the chat (read-only).  
> Added katas/type-system/README.md to the chat (read-only).  
> Added katas/determinism/README.md to the chat (read-only).  
> Added katas/concurrency/09-stm/README.md to the chat (read-only).  
> Added katas/advanced/02-solver-types/README.md to the chat (read-only).  
> Added katas/README.md to the chat (read-only).  
> Added katas/foundations/README.md to the chat (read-only).  
> Added koans/advanced/07-solver-any-inst/README.md to the chat (read-only).  
> Added katas/tooling/06-property-testing/README.md to the chat (read-only).  
> Added katas/determinism/07-promise-equiv-solutions/README.md to the chat (read-only).  

#### You are reviewing the Cinnabar Mercury curriculum project in the current directory. Cinnabar is a post-tutorial exercise repository for Mercury programmers — katas, koans, bridges, and puzzles organized into tracks.  
####   
#### REVIEW FOCUS: Coverage — breadth and depth of Mercury language concepts.  
####   
#### You have been given all track-level READMEs and several exercise READMEs.  
####   
#### Evaluate:  
#### 1. BREADTH: What are the major Mercury language concepts? Which are covered, which are absent or thin?  
####    Key areas to check: determinism (all 6 categories), mode system (insts, multi-mode, uniqueness), type system (ADTs, parametric polymorphism, typeclasses, existential types, phantom types), higher-order predicates (inst annotations, partial application), DCG parsing, concurrency (parallel conjunction, channels, unique state, STM), meta-programming, FFI, standard library (list, map, set, string, io), solver types, property-based testing, error handling patterns.  
####   
#### 2. DEPTH: Do harder concepts get harder exercises? Does the curriculum plateau at an intermediate level, or does it push into advanced Mercury?  
####   
#### 3. SEQUENCING: Are concepts introduced in the right order? Are there cases where an exercise assumes knowledge not yet covered?  
####   
#### 4. GAPS: What important Mercury concept is most notably absent? What would a post-tutorial learner most likely need that isn't here?  
####   
#### 5. REDUNDANCY: Are any concepts over-covered relative to their importance?  
####   
#### Be specific about which tracks/exercises cover which concepts. Rate coverage breadth and depth separately on 1–10 scales.  

<thinking-content-7bbeb8e1441453ad999a0bbba8a46d4b>



Let me carefully analyze the Cinnabar Mercury curriculum based on all the reference materials provided. I need to evaluate coverage breadth and depth, sequencing, gaps, and redundancy.

**BREADTH ANALYSIS — Mapping concepts to coverage:**

1. **Determinism (all 6 categories):**
   - Covered in `katas/determinism/` with 7 katas
   - README mentions: `01-six-categories/` (det, semidet, multi, nondet, erroneous, failure), `02-committed-choice/` (cc_multi/cc_nondet, promise_equivalent_solutions), `03-scope-annotations/` (require_complete_switch, require_det), `07-promise-equiv-solutions/` (two forms)
   - That's 4 out of 7 katas documented. Missing: 04, 05, 06 presumably exist but aren't described in the provided README.
   - Coverage: All 6 categories are addressed. Good.

2. **Mode system (insts, multi-mode, uniqueness, higher-order insts):**
   - Covered in `katas/mode-system/` with 8 katas (per main README)
   - Documented katas: `01-insts-and-modes/` (user-defined insts, bound(...) patterns, parametric insts), `02-multi-mode/` (mode-specific clauses, promise_equivalent_clauses), `03-uniqueness-deep/` (arrays, di/uo, uniqueness loss, version_array), `04-higher-order-insts/` (dispatch tables, inst annotations on HO values), `05-mode-specific-clauses/` (my_append/3 with three modes), `08-array-threading/` (array(T) vs version_array(T))
   - Missing from docs: 06, 07 (presumably exist)
   - Coverage: insts ✓, multi-mode ✓, uniqueness ✓, higher-order insts ✓, di/uo threading ✓

3. **Type system (ADTs, parametric polymorphism, typeclasses, existential types, phantom types):**
   - Covered in `katas/type-system/` with 10 katas
   - Documented: `01-discriminated-unions/` (recursive ADTs, total pattern matching, semidet constructors), `02-parametric-polymorphism/` (tree(T), polymorphic predicates), `03-abstract-types/` (opaque types, representation independence), `04-type-classes/` (typeclass declaration, instance syntax), `05-existential-types/` (heterogeneous containers, OOP-style dispatch)
   - 5 out of 10 documented. Missing: 06-10 presumably.
   - Phantom types: Not explicitly mentioned. Could be covered in the undocumented katas or could be a gap.

4. **Higher-order predicates (inst annotations, partial application):**
   - `katas/foundations/04-higher-order/` mentions: higher-order predicates, list.map/filter/foldl2, storing preds in variables
   - `katas/mode-system/04-higher-order-insts/` covers inst annotations on HO values
   - Bridge 06 mentions "Higher-order predicates with inst annotations"
   - Partial application: Not explicitly mentioned anywhere in the documents.
   - Coverage: Moderate — basic HO covered, inst annotations on HO covered, but partial application seems absent.

5. **DCG parsing:**
   - `katas/parsing/` with 9 katas (per main README) but only 3 documented
   - Documented: `01-dcg-basics/` (DCG syntax, -->, alternatives), `02-dcg-goals/` ({Goal} semantic actions), `03-parsing-utils/` (parsing_utils, config file parser)
   - 6 undocumented katas presumably cover more advanced parsing
   - Coverage: Good foundation, but details of the 6 advanced parsing katas unknown.

6. **Concurrency (parallel conjunction, channels, unique state, STM):**
   - `katas/concurrency/` with 9 katas
   - Documented: `01-parallel-conjunction/`, `02-threads/` (thread.spawn, thread.channel), `03-concurrent-io/`, `04-granularity/`, `05-deadlock/`, `06-parallel-map-fold/`, `07-uniqueness-and-threads/`, `08-deterministic-parallelism/`, `09-stm/`
   - All 9 documented with topics. Excellent coverage.
   - Coverage: Comprehensive — parallel & (det/cc_multi), threads, channels, unique state across threads, STM with retry/or_else.

7. **Meta-programming:**
   - Mentioned in puzzles ("Mercury meta-interpreter" in advanced puzzles)
   - Bridge 05 mentions "mode-reversal" and "multi-mode predicates"
   - The `assoc_list_env` kata (advanced/05) mentions "the idiom the meta-interpreter uses"
   - No dedicated track — appears as a single puzzle
   - Coverage: Thin. Only a single puzzle, not a track.

8. **FFI:**
   - `katas/advanced/01-ffi-depth/` covers all four FFI pragmas
   - `katas/advanced/07-ffi-pragma-attrs/` covers will_not_call_mercury, promise_pure, thread_safe
   - `CLP-PLAN.md` discusses FFI for Rust CLP engine
   - Coverage: Good — both basic FFI and pragma attributes covered.

9. **Standard library (list, map, set, string, io):**
   - `foundations/02-maybe/` — maybe(T)
   - `foundations/03-string/` — string module
   - `foundations/04-higher-order/` — list.map/filter/foldl2
   - `foundations/05-map/` — map(K,V)
   - `foundations/06-set/` — set(T)
   - `foundations/07-exceptions/` — io.res, exception.catch_any, file I/O
   - `foundations/08-built-in-types/` — Integer, float, char, string corners
   - Coverage: Good coverage of core stdlib modules.

10. **Solver types:**
    - `katas/advanced/02-solver-types/` — reference kata
    - `koans/advanced/07-solver-any-inst/` — koan on any vs ground
    - `CLP-PLAN.md` — extensive plan for CLP engine
    - Coverage: Type-system hook is documented but no working constraint engine. The kata is explicitly a reference with pseudocode.

11. **Property-based testing:**
    - `katas/tooling/06-property-testing/` — full kata with generators, properties, runner
    - Coverage: Good — complete pattern with examples.

12. **Error handling patterns:**
    - `bridge/11-error-handling/` — maybe chaining, custom error types, io.res for file loading
    - Coverage: Excellent — three distinct error mechanisms with clear guidance on when to use each.

13. **Tooling (grades, debugging, profiling, tabling, testing):**
    - `katas/tooling/` with 6 katas
    - All documented: grades, debugging with mdb, profiling, tabling (pragma memo), testing (assertion pattern), property testing
    - Coverage: Good practical coverage of the tooling ecosystem.

14. **Memoization:**
    - `katas/advanced/04-pragma-memo/` — pragma memo + manual memoization via state-threaded map
    - Also mentioned in tooling/tabling
    - Coverage: Good.

15. **Abstract types / information hiding:**
    - `katas/type-system/03-abstract-types/`
    - `katas/advanced/06-abstract-module/`
    - Coverage: Good — covered from two angles (type system and module system).

**DEPTH ANALYSIS:**

The curriculum starts with foundations (reactivation, modules, maybe, string, HO, map, set, exceptions, built-in types, mode inference) — solid beginner-to-intermediate.

Mode system track goes deep: insts → multi-mode → uniqueness (di/uo) → higher-order insts → mode-specific clauses → array threading. This is genuinely advanced material.

Determinism track covers all 6 categories plus committed choice, scope annotations, and promise_equivalent_solutions. Good depth.

Concurrency track is thorough: parallel conjunction → threads → concurrent IO → granularity → deadlock → parallel map → uniqueness with threads → deterministic parallelism → STM. This is one of the strongest tracks.

Type system covers ADTs, parametric polymorphism, abstract types, typeclasses, existential types. Good but 5 of 10 katas are documented — hard to assess full depth.

Parsing covers DCG basics, DCG goals, parsing utils. 3 of 9 documented — the undocumented ones might push into advanced territory.

Advanced track covers FFI, solver types, RTTI, memoization, assoc-list envs, abstract modules, FFI pragma attrs. This is genuinely advanced.

Puzzles section mentions: Sudoku, N-queens, crypto-arithmetic, anagram finder, expression evaluator, graph reachability, frequency histogram, calculator, CSV reader, config parser, parallel sort, pipeline, pipeline with unique state, generic printer, memoized search, bidirectional search, combinator library, generic parser, plugin architecture, Mercury meta-interpreter. This is a strong set of advanced exercises.

Bridges provide integration exercises combining multiple concepts.

**Does it plateau at intermediate?**
No — the advanced track, STM, uniqueness, solver types, FFI, meta-interpreter puzzle, and bridges push well into advanced territory. The curriculum goes from "finished the tutorial" to genuinely advanced Mercury.

**SEQUENCING ANALYSIS:**

- Foundations first ✓ (modules, maybe, string, HO, data structures, exceptions, mode inference)
- Type system after foundations ✓ (builds on basics)
- Mode system after type system ✓ (modes are harder, need type system fluency)
- Determinism after mode system ✓ (closely related, modes are prerequisite)
- Parsing after determinism ✓ (DCGs use modes extensively)
- Tooling can go anywhere ✓ (practical skills)
- Concurrency after modes/determinism ✓ (needs mode fluency, unique modes)
- Advanced after all tracks ✓ (FFI, solver types, RTTI are expert-level)
- Bridges placed between tracks as integration exercises ✓

The recommended order in README.md: Foundations → Type system → Mode system → Determinism → Parsing → Tooling/Concurrency/Advanced. This is sensible.

Potential issue: Bridge 05 (mode-reversal) requires mode system knowledge but is listed after parsing. The recommended order puts bridges 04-06 after mode system and determinism, which makes sense.

Bridge 11 (error-handling) lists prerequisites as `foundations/02-maybe` and `foundations/07-io-error-handling`. ✓

Koan `advanced/07-solver-any-inst` lists prerequisites of `advanced/02-solver-types` and `advanced/01-ffi-depth`. ✓

**GAPS ANALYSIS:**

1. **Partial application / currying**: Mercury supports partial application of higher-order predicates (e.g., `list.map(f)` where f is a partially applied predicate). This is not explicitly covered anywhere. It's an important practical idiom.

2. **Phantom types**: Not explicitly covered. Phantom types are used in Mercury for type-safe abstractions (e.g., phantom type parameters for units of measurement, state tokens). This is a niche but powerful technique.

3. **Type class instances with functional dependencies**: Type classes are covered but functional dependencies (which are important for type-level computation and multi-parameter type classes) are not explicitly addressed.

4. **Module system depth**: `import_module` vs `use_module` is mentioned in abstract module kata, but the broader module system (nested modules, module qualifiers, interface files generation) could be deeper.

5. **Termination and productivity**: Mercury has termination checking. This is not covered as a concept.

6. **Solver types / CLP**: The coverage is explicitly acknowledged as incomplete — there's no working constraint engine. The kata is a reference with pseudocode. This is the most notable gap, but it's honestly documented as a known limitation with a concrete plan to address it.

7. **Groundness and aliasing**: While uniqueness is covered, the interaction between groundness testing (`ground/1`) and aliasing patterns could be deeper.

8. **DCG advanced features**: Only 3 of 9 parsing katas are documented. It's unclear if the remaining 6 cover advanced DCG features like DCG threading, attribute DCGs, etc.

9. **Tabling**: Mentioned in tooling (pragma memo) but Mercury's full tabling system (answer subsumption, etc.) is not deeply covered.

10. **Impure features**: `impure` predicates, `semipure` — not explicitly covered. These are important for understanding the full purity spectrum.

11. **Foreign enum / constants**: FFI covers pragmas but foreign enum declarations are not explicitly shown.

12. **Aggregation / search**: While puzzles may cover this, there's no explicit track on search strategies, `promise_equivalent_solutions` for aggregation, etc. beyond what's in determinism.

**REDUNDANCY ANALYSIS:**

1. **`promise_equivalent_clauses`** appears in both mode-system (`02-multi-mode`) and determinism (`02-committed-choice`). This is appropriate — the concept genuinely spans both concerns.

2. **`promise_equivalent_solutions`** appears in determinism (`02-committed-choice`, `07-promise-equiv-solutions`) and is referenced in concurrency (`07-uniqueness-and-threads`). Again, appropriate — it's a cross-cutting concept.

3. **`version_array`** appears in both mode-system (`03-uniqueness-deep`, `08-array-threading`) and concurrency (`07-uniqueness-and-threads`). This is appropriate — it's the key data structure for both uniqueness and concurrency.

4. **`maybe(T)`** appears in foundations (`02-maybe`) and bridge 11 (error-handling). The bridge extends the foundations concept. Appropriate — not redundant, it builds on it.

5. **Higher-order predicates** appear in foundations (`04-higher-order`), mode-system (`04-higher-order-insts`), and advanced (`05-assoc-list-env`). Each adds a layer. Not redundant — progressive deepening.

6. I don't see significant over-coverage of any concept relative to its importance. The curriculum seems well-balanced.

**RATINGS:**

Breadth: The curriculum covers most major Mercury concepts well. Notable absences are partial application, phantom types, functional dependencies, termination/productivity, impure features, and a working CLP engine. But the core post-tutorial topics are well-represented.

I'd rate breadth at **7.5/10** — strong coverage of core concepts, with some notable absences in advanced type system features and a few practical idioms.

Depth: The curriculum goes from intermediate to genuinely advanced. Mode system, concurrency, and advanced tracks are particularly deep. The solver types coverage is acknowledged as incomplete. Parsing depth is hard to assess with only 3/9 katas documented.

I'd rate depth at **7.5/10** — goes well beyond tutorial level in many areas, but solver types are thin by necessity, and some advanced topics are missing.

Let me now compose a thorough, specific review.

</thinking-content-7bbeb8e1441453ad999a0bbba8a46d4b>

## Cinnabar Curriculum Review: Coverage

### 1. BREADTH — What's Covered

**Strong coverage (well-documented, multi-exercise tracks):**

| Concept | Track/Exercises | Assessment |
|---|---|---|
| **Determinism (all 6 categories)** | `katas/determinism/` — 7 katas | All categories addressed: det, semidet, multi, nondet, erroneous, failure. Committed choice, scope annotations, and `promise_equivalent_solutions` both forms. **Strong.** |
| **Mode system** | `katas/mode-system/` — 8 katas | Insts, user-defined insts, `bound(...)` patterns, parametric insts, multi-mode clauses, `promise_equivalent_clauses`, uniqueness (`di`/`uo`), higher-order inst annotations, array threading. **Excellent.** |
| **Concurrency** | `katas/concurrency/` — 9 katas | Parallel conjunction (`&`), threads + channels, concurrent IO, granularity, deadlock, parallel map, unique state across threads, deterministic parallelism, STM with `retry`/`or_else`. **Excellent — one of the strongest tracks.** |
| **Type system** | `katas/type-system/` — 10 katas | Discriminated unions (recursive ADTs, semidet constructors), parametric polymorphism, abstract types, typeclasses, existential types. 5 of 10 documented; remaining 5 undocumented so depth unclear. **Good from what's visible.** |
| **Standard library** | `katas/foundations/` | `maybe(T)`, `string`, higher-order list operations (`map`/`filter`/`foldl2`), `map(K,V)`, `set(T)`, `io.res`, `exception.catch_any`, built-in types (`//` vs `rem`, float, char). **Good.** |
| **FFI** | `katas/advanced/01`, `07` + `CLP-PLAN.md` | All four FFI pragmas (`foreign_decl`, `foreign_type`, `foreign_proc`, `foreign_export`), plus `will_not_call_mercury`, `promise_pure`, `thread_safe` attributes. **Good.** |
| **Error handling** | `bridge/11` | `maybe(T)` chaining, custom error types (`validation_result`), `io.res` for file loading — with clear guidance on when each is appropriate. **Excellent.** |
| **Property-based testing** | `katas/tooling/06` | Full pattern: bounded generators, semidet properties, `solutions/2` runner, counterexample reporting. **Good and practical.** |
| **Tooling ecosystem** | `katas/tooling/` — 6 katas | Grades, `mdb` debugging, profiling, `pragma memo`/tabling, assertion testing, property testing. **Good.** |
| **Parsing (DCG)** | `katas/parsing/` — 9 katas | DCG syntax, `{Goal}` semantic actions, `parsing_utils` combinators. 3 of 9 documented; remaining 6 undocumented. **Foundation is solid; advanced depth unclear.** |

**Partial coverage (present but thin):**

| Concept | Where | Assessment |
|---|---|---|
| **Solver types / CLP** | `katas/advanced/02` (reference kata), `koans/advanced/07`, `CLP-PLAN.md` | Explicitly acknowledged as incomplete — no working constraint engine. The kata is pseudocode with honest explanation of what's missing. `CLP-PLAN.md` outlines a concrete Rust FFI plan. **Thin by necessity, but honestly documented.** |
| **Meta-programming** | Advanced puzzle (meta-interpreter), `advanced/05-assoc-list-env` | Mentioned as a single puzzle, not a track. The assoc-list env kata hints at the idiom. **Thin — only a taste.** |
| **Memoization** | `katas/advanced/04`, `katas/tooling/04` | `pragma memo` + manual state-threaded map. **Adequate.** |
| **Abstract types / modules** | `katas/type-system/03`, `katas/advanced/06` | Covered from two angles (type opacity and module abstraction). **Good.** |

**Absent or not visible:**

| Concept | Status |
|---|---|
| **Partial application / currying** | Not covered anywhere. Mercury's partial application of higher-order predicates (e.g., `list.map(f)`) is an important practical idiom not addressed. |
| **Phantom types** | Not mentioned. Phantom type parameters for type-safe abstractions (units, state tokens) are a powerful Mercury idiom. |
| **Functional dependencies** | Type classes are covered but multi-parameter type classes with fundeps are not. |
| **Termination / productivity checking** | Not covered as a concept. |
| **`impure` / `semipure` predicates** | The full purity spectrum is not explicitly taught. |
| **Foreign enum / constant declarations** | FFI pragmas are covered but `foreign_enum` is absent. |
| **Aggregation patterns** | Beyond `promise_equivalent_solutions`, there's no explicit track on search/aggregation idioms. |

---

### 2. DEPTH — Does the Curriculum Push Into Advanced Mercury?

The curriculum does **not** plateau at intermediate. The progression is clear:

- **Foundations** (intermediate): modules, basic types, stdlib usage, mode inference
- **Mode system** (advanced): inst reasoning, uniqueness, `di`/`uo` threading, HO inst annotations
- **Determinism** (advanced): all 6 categories, committed choice, scope annotations
- **Concurrency** (advanced): STM, unique state across threads, granularity analysis, deadlock
- **Advanced track** (expert-level): FFI depth, solver types, RTTI, memoization patterns, abstract modules
- **Bridges** (integration): each combines multiple tracks into a cohesive exercise
- **Puzzles** (open-ended): meta-interpreter, plugin architecture, bidirectional search, combinator library

The mode system and concurrency tracks are particularly deep — they don't just teach the concepts, they force the learner to internalize them through repetition. The STM kata is one of the best single exercises in the repository, building from `deposit`/`withdraw` through `retry`/`or_else` in small steps.

**Depth rating: 7.5/10** — Goes well beyond tutorial level. The main limitation is solver types (acknowledged gap). Parsing depth is hard to evaluate with 6/9 katas undocumented.

---

### 3. SEQUENCING — Is the Order Right?

The recommended order from `README.md` is:

> Foundations → Type system → Mode system → Determinism → Parsing → Tooling, Concurrency, Advanced (any order)

This is **correct and well-reasoned**:

- Foundations before everything else ✓
- Type system before mode system ✓ (you need to understand types to reason about insts)
- Mode system before determinism ✓ (modes and determinism are deeply intertwined)
- Mode system before concurrency ✓ (unique modes, `di`/`uo` threading are prerequisites for STM and thread safety)
- Determinism before parsing ✓ (DCGs interact with mode/determinism checking)
- Advanced last ✓ (FFI, solver types, RTTI require fluency in everything else)

**Cross-reference integrity is good:**
- Bridge 11 lists `foundations/02-maybe` and `foundations/07-io-error-handling` as prerequisites ✓
- Koan `advanced/07-solver-any-inst` lists `advanced/02-solver-types` and `advanced/01-ffi-depth` ✓
- Determinism `07-promise-equiv-solutions` lists concurrency and mode-system prerequisites ✓

**One minor concern:** Bridge 05 (mode-reversal) sits between bridges 04 (determinism-ratchet) and 06 (pipeline-parameterization), which is correct thematically, but a learner who hasn't completed the full mode system track might struggle. The recommended order says "Bridges 04–06 after Mode system and Determinism," which is the right call.

---

### 4. GAPS — The Most Notable Absence

**The single most notable gap is partial application and currying of higher-order predicates.**

Mercury supports partial application in a way that is central to idiomatic code:

```mercury
% Partial application of a predicate
Doubler = list.map(func(X) = Y :- Y = X * 2),
% Or using a named predicate
Doubled = list.map(double, List)
```

This interacts with mode annotations in non-obvious ways (the mode of a partially applied predicate must be compatible with how it's eventually called). Every real Mercury codebase uses this pattern constantly, and the curriculum doesn't explicitly teach it.

**Second most notable gap: the solver type / CLP story is incomplete.** This is honestly documented as a known limitation, and `CLP-PLAN.md` provides a concrete roadmap. But a post-tutorial learner who wants to do constraint logic programming in Mercury will hit a wall. The koan (`advanced/07`) teaches the mode-checking side of `any` inst, but there's no way to actually build and run a CLP program.

**Third gap: impure/semipure predicates.** The purity spectrum (`det`/`semidet`/`multi`/`nondet` is one axis; `pure`/`semipure`/`impure` is another) is not explicitly taught. Learners will encounter `impure` in real code and in compiler errors without understanding the design rationale.

---

### 5. REDUNDANCY — Over-Covered Concepts

**There is no significant redundancy.** The curriculum is lean. Cross-cutting concepts like `promise_equivalent_solutions`, `version_array`, and `promise_equivalent_clauses` appear in multiple tracks, but each appearance adds a new layer of context rather than repeating the same material:

- `promise_equivalent_clauses` in mode-system → `promise_equivalent_solutions` in determinism → `[!:IO]` form in concurrency: progressive deepening, not repetition.
- `version_array` in mode-system/uniqueness → in concurrency/unique-state: same data structure, different problem domain.
- `maybe(T)` in foundations → in bridge 11: builds on the foundation with validation patterns.

No concept is drilled past the point of diminishing returns.

---

### Summary Ratings

| Dimension | Score | Rationale |
|---|---|---|
| **Breadth** | **7.5 / 10** | Covers all major post-tutorial topics except partial application, phantom types, fundeps, impure predicates, and termination checking. Solver types are present but non-functional. |
| **Depth** | **7.5 / 10** | Genuinely advanced in modes, determinism, and concurrency. Solver types are thin (acknowledged). Parsing advanced features undocumented. Meta-programming is a single puzzle. |
| **Sequencing** | **9 / 10** | Logical, well-documented prerequisites, no forward-reference issues detected. |
| **Gaps** | Most notable: **partial application/currying** and **impure predicates**. Solver types are a known, honestly-documented gap. |
| **Redundancy** | **Low** — No concepts are meaningfully over-covered. Cross-track appearances are additive. |

> Tokens: 12k sent, 5.8k received. Cost: $0.0045 message, $0.0045 session.  
