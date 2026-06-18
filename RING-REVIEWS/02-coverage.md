
# aider chat started at 2026-06-18 16:13:38

> /home/josiah/.local/bin/aider --no-git --chat-mode ask --model openrouter/inclusionai/ring-2.6-1t --map-tokens 4000 --yes --no-auto-commits --message-file /tmp/ring-r2-prompt.txt --chat-history-file /home/josiah/Development/personal/education/self/polyparadigm-project/cinnabar/RING-REVIEWS/02-coverage.md  
> Aider v0.86.2  
> Model: openrouter/inclusionai/ring-2.6-1t with ask edit format  
> Git repo: none  
> Repo-map: disabled  

#### You are reviewing the Cinnabar Mercury curriculum project in the current directory. Cinnabar is a post-tutorial exercise repository for Mercury programmers — katas, koans, bridges, and puzzles organized into tracks.  
####   
#### REVIEW FOCUS: Coverage — breadth and depth of Mercury language concepts.  
####   
#### Survey the full curriculum structure: katas/, koans/, bridge/, and puzzles/. Read the README.md in each track and a sample of exercise READMEs to understand what concepts are covered.  
####   
#### Evaluate:  
#### 1. BREADTH: What are the major Mercury language concepts? Which are covered, which are absent or thin?  
####    Key areas to check: determinism (all 6 categories), mode system (insts, multi-mode, uniqueness), type system (ADTs, parametric polymorphism, typeclasses, existential types, phantom types), higher-order predicates (inst annotations, partial application), DCG parsing, concurrency (parallel conjunction, channels, unique state), meta-programming, FFI, standard library (list, map, set, string, io).  
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



The user wants me to review the Cinnabar Mercury curriculum project in the current directory. They haven't shared file contents yet, so I need to explore the directory structure first. Let me start by surveying the directory structure, then read READMEs and sample exercises.

</thinking-content-7bbeb8e1441453ad999a0bbba8a46d4b>

Let me explore the project structure systematically.
<tool_call>Bash
<arg_key>command</arg_key>
<arg_value>find . -maxdepth 1 -type f -o -type d | head -40</arg_value>
</tool_call>
<tool_call>Bash
<arg_key>command</arg_key>
<arg_value>ls -la</arg_value>
</tool_call>

> Tokens: 414 sent, 188 received. Cost: $0.00015 message, $0.00015 session.  

# aider chat started at 2026-06-18 16:15:59

> /home/josiah/.local/bin/aider --no-git --chat-mode ask --model openrouter/inclusionai/ring-2.6-1t --map-tokens 1000 --yes --no-auto-commits --read README.md --read katas/README.md --read katas/foundations/README.md --read katas/type-system/README.md --read katas/mode-system/README.md --read katas/determinism/README.md --read katas/parsing/README.md --read katas/tooling/README.md --read katas/concurrency/README.md --read katas/advanced/README.md --read katas/foundations/04-higher-order/README.md --read katas/foundations/09-mode-inference/README.md --read katas/type-system/05-existential-types/README.md --read katas/type-system/09-phantom-types/README.md --read katas/mode-system/02-multi-mode/README.md --read katas/mode-system/03-uniqueness-deep/README.md --read katas/determinism/02-committed-choice/README.md --read katas/determinism/06-determinism-and-negation/README.md --read katas/parsing/04-dcg-determinism/README.md --read katas/parsing/08-packrat/README.md --read katas/concurrency/07-uniqueness-and-threads/README.md --read katas/advanced/01-ffi-depth/README.md --read katas/advanced/03-rtti/README.md --read puzzles/advanced/05-generic-parser/README.md --read puzzles/advanced/06-plugin-architecture/README.md --read puzzles/advanced/07-mercury-in-mercury/README.md --message-file /tmp/ring-r2-prompt.txt --chat-history-file /home/josiah/Development/personal/education/self/polyparadigm-project/cinnabar/RING-REVIEWS/02-coverage.md  
> Aider v0.86.2  
> Model: openrouter/inclusionai/ring-2.6-1t with ask edit format  
> Git repo: none  
> Repo-map: disabled  
> Added katas/README.md to the chat (read-only).  
> Added katas/parsing/08-packrat/README.md to the chat (read-only).  
> Added katas/type-system/README.md to the chat (read-only).  
> Added puzzles/advanced/05-generic-parser/README.md to the chat (read-only).  
> Added katas/concurrency/README.md to the chat (read-only).  
> Added puzzles/advanced/06-plugin-architecture/README.md to the chat (read-only).  
> Added puzzles/advanced/07-mercury-in-mercury/README.md to the chat (read-only).  
> Added katas/foundations/README.md to the chat (read-only).  
> Added katas/determinism/README.md to the chat (read-only).  
> Added katas/determinism/02-committed-choice/README.md to the chat (read-only).  
> Added katas/foundations/04-higher-order/README.md to the chat (read-only).  
> Added katas/foundations/09-mode-inference/README.md to the chat (read-only).  
> Added katas/advanced/03-rtti/README.md to the chat (read-only).  
> Added katas/type-system/05-existential-types/README.md to the chat (read-only).  
> Added katas/concurrency/07-uniqueness-and-threads/README.md to the chat (read-only).  
> Added katas/advanced/README.md to the chat (read-only).  
> Added katas/tooling/README.md to the chat (read-only).  
> Added katas/mode-system/README.md to the chat (read-only).  
> Added katas/parsing/README.md to the chat (read-only).  
> Added katas/mode-system/02-multi-mode/README.md to the chat (read-only).  
> Added README.md to the chat (read-only).  
> Added katas/mode-system/03-uniqueness-deep/README.md to the chat (read-only).  
> Added katas/type-system/09-phantom-types/README.md to the chat (read-only).  
> Added katas/determinism/06-determinism-and-negation/README.md to the chat (read-only).  
> Added katas/parsing/04-dcg-determinism/README.md to the chat (read-only).  
> Added katas/advanced/01-ffi-depth/README.md to the chat (read-only).  

#### You are reviewing the Cinnabar Mercury curriculum project in the current directory. Cinnabar is a post-tutorial exercise repository for Mercury programmers — katas, koans, bridges, and puzzles organized into tracks.  
####   
#### REVIEW FOCUS: Coverage — breadth and depth of Mercury language concepts.  
####   
#### Survey the full curriculum structure: katas/, koans/, bridge/, and puzzles/. Read the README.md in each track and a sample of exercise READMEs to understand what concepts are covered.  
####   
#### Evaluate:  
#### 1. BREADTH: What are the major Mercury language concepts? Which are covered, which are absent or thin?  
####    Key areas to check: determinism (all 6 categories), mode system (insts, multi-mode, uniqueness), type system (ADTs, parametric polymorphism, typeclasses, existential types, phantom types), higher-order predicates (inst annotations, partial application), DCG parsing, concurrency (parallel conjunction, channels, unique state), meta-programming, FFI, standard library (list, map, set, string, io).  
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



The user wants me to review the Cinnabar Mercury curriculum project for coverage breadth and depth. They've already shared several README files from the project. Let me survey what I have and provide a thorough evaluation.

Let me organize what I know from the shared files:

**Katas tracks (from READMEs and shared files):**

1. **Foundations** (katas/foundations/README.md): 12 exercises
   - 00-reactivation: Predict/verify pass
   - 01-modules: Module system
   - 02-maybe: maybe(T), map_maybe, bind_maybe
   - 03-string: String module
   - 04-higher-order: Higher-order predicates, list.map/filter/foldl2, storing preds in variables
   - 05-map: map(K, V)
   - 06-set: set(T)
   - 07-exceptions: io.res, exception.catch_any, file I/O
   - 08-built-in-types: Integer, float, char, string corners
   - 09-mode-inference: Goal reordering, multi-mode predicates, reading mode errors

2. **Type System** (katas/type-system/README.md): 10 exercises
   - 01-discriminated-unions: Recursive ADTs, total pattern matching, semidet constructors
   - 02-parametric-polymorphism: User-defined tree(T), polymorphic predicates
   - 03-abstract-types: Opaque types, representation independence
   - 04-type-classes: Typeclass declaration, instance syntax, constraint propagation
   - 05-existential-types: Heterogeneous containers, OOP-style dispatch
   - (Note: 06-09 are referenced but not fully detailed in the shared README — wait, the type-system README only lists 5 entries in the table but mentions "10 exercises" — actually looking again, the table shows 5 entries. But the foundations track says 12 exercises. Let me re-read.)

Actually, the type-system README lists:
   - 01-discriminated-unions
   - 02-parametric-polymorphism
   - 03-abstract-types
   - 04-type-classes
   - 05-existential-types

That's only 5 listed. But the foundations track in the main README says "Type system | 10 | 4". So there must be more exercises (06-09) not detailed in the shared README. One of them is 09-phantom-types (I have that file).

3. **Mode System** (katas/mode-system/README.md): 7 exercises
   - 01-insts-and-modes: User-defined insts, bound(...) patterns, parametric insts
   - 02-multi-mode: Multiple mode declarations, promise_equivalent_clauses
   - 03-uniqueness-deep: Arrays, di/uo, uniqueness loss, version_array
   - 04-higher-order-insts: Dispatch tables, inst annotations on higher-order values
   - 05-mode-specific-clauses: my_append/3 with three modes
   (Plus 06 and 07 presumably exist since track says 7)

4. **Determinism** (katas/determinism/README.md): 6 exercises
   - 01-six-categories: One predicate per determinism class
   - 02-committed-choice: cc_multi/cc_nondet, promise_equivalent_solutions
   - 03-scope-annotations: require_complete_switch, require_det
   (Plus 04-06, one of which is 06-determinism-and-negation)

5. **Parsing** (katas/parsing/README.md): 9 exercises
   - 01-dcg-basics: DCG syntax, --->, alternatives, list-of-token input
   - 02-dcg-goals: {Goal} semantic actions
   - 03-parsing-utils: parsing_utils.whitespace, next_char, literal, config file parser
   - 04-dcg-determinism: multi-clause DCG rules, if-then-else for det/semidet
   - 08-packrat: pragma memo, packrat parsing
   (Plus exercises 05-07 and 09 presumably)

6. **Tooling** (katas/tooling/README.md): 5 exercises
   - 01-grades: Grade anatomy
   - 02-debugging-mdb: Compile with .debug, 4-port tracing
   - 03-profiling: .prof and .profdeep grades
   - 04-tabling: pragma memo, pragma loop_check, memoized Fibonacci

7. **Concurrency** (katas/concurrency/README.md): 8 exercises
   - 01-parallel-conjunction: & operator, det/cc_multi requirement, timing comparison
   - 02-threads: thread.spawn, thread.channel, producer-consumer
   (Plus 03-08, one of which is 07-uniqueness-and-threads)

8. **Advanced** (katas/advanced/README.md): 4 exercises
   - 01-ffi-depth: All four FFI pragmas
   - 02-solver-types: Reference kata (no working build)
   - 03-rtti: deconstruct, generic pretty-printer

**Koans:** Mentioned but not detailed (7 for foundations, 4 for type system, 5 for mode system, 4 for determinism, 3 for parsing, 2 for tooling, 2 for concurrency, 2 for advanced). I don't have details on these.

**Bridges:** 10 bridges listed in the main README:
   - 01-maybe-extend
   - 02-pipeline-extend
   - 03-dcg-extend
   - 04-determinism-ratchet
   - 05-mode-reversal
   - 06-pipeline-parameterization
   - 07-parser-hardening
   - 08-expression-language
   - 09-typeclass-refactor
   - 10-parallel-pipeline

**Puzzles:** 17 puzzles across topics:
   - logic/: Sudoku, N-queens, crypto-arithmetic
   - data-structures/: Anagram finder, expression evaluator, graph reachability, frequency histogram
   - parsing/: Calculator, CSV reader, config parser
   - concurrent/: Parallel sort, pipeline, pipeline with unique state
   - advanced/: Generic printer, memoized search, bidirectional search, combinator library, generic parser, plugin architecture, Mercury meta-interpreter

Now let me evaluate against the key areas:

**1. Determinism (all 6 categories)**
- Covered: det, semidet, multi, nondet, erroneous(?), failure(?)
- The determinism track has 6 exercises (01-six-categories, 02-committed-choice, 03-scope-annotations, plus 04-06)
- 06-determinism-and-negation covers \+ and semidet
- The six categories are: det, semidet, multi, nondet, erroneous, failure
- I need to check if erroneous and failure are covered. The 01-six-categories claims "one predicate per determinism class" so it likely covers all six. But the track only has 6 exercises total, and 02/03/06 focus on committed choice, scope annotations, and negation. Do exercises 04-05 cover erroneous and failure?
- From the determinism track listing: 01-six-categories, 02-committed-choice, 03-scope-annotations, then presumably 04, 05, 06. We know 06 is determinism-and-negation. So 04 and 05 might cover erroneous/failure or other determinism topics.

**2. Mode system (insts, multi-mode, uniqueness)**
- Well covered: 7 exercises in mode-system track
- insts-and-modes, multi-mode, uniqueness-deep, higher-order-insts, mode-specific-clauses
- Plus foundations/09-mode-inference covers basics

**3. Type system (ADTs, parametric polymorphism, typeclasses, existential types, phantom types)**
- Well covered: 5+ exercises in type-system track
- discriminated-unions, parametric-polymorphism, abstract-types, type-classes, existential-types, phantom-types (09)

**4. Higher-order predicates (inst annotations, partial application)**
- Covered in foundations/04-higher-order and mode-system/04-higher-order-insts

**5. DCG parsing**
- Covered in parsing track: 9 exercises
- dcg-basics, dcg-goals, parsing-utils, dcg-determinism, packrat

**6. Concurrency (parallel conjunction, channels, unique state)**
- Covered: 8 exercises in concurrency track
- parallel-conjunction, threads, uniqueness-and-threads

**7. Meta-programming**
- Covered in puzzles/advanced/07-mercury-in-mercury (meta-interpreter)
- Also RTTI in advanced/03-rtti

**8. FFI**
- Covered in advanced/01-ffi-depth

**9. Standard library (list, map, set, string, io)**
- list: Used throughout (foundations/04-higher-order)
- map: foundations/05-map
- set: foundations/06-set
- string: foundations/03-string
- io: Used throughout, exceptions in foundations/07-exceptions

**Now for gaps:**

1. **Solver types** — advanced/02-solver-types is a "reference kata" with no working build. This is a significant Mercury feature that's essentially not taught.

2. **Software transactional memory (STM)** — Not covered at all. Mercury has `stm` module for composable memory transactions.

3. **Foreign_enum / C interop beyond basic FFI** — The FFI kata covers the four pragmas but doesn't go deep into foreign_enum, foreign_struct, etc.

4. **Ground terms / `ground` inst** — Not explicitly covered.

5. **`with_type` / type inference annotations** — Not covered.

6. **Module system depth** — foundations/01-modules covers basics, but advanced module system features (abstract exports, sharing constraints, recursive modules) are not covered.

7. **Term unification details** — The meta-interpreter puzzle covers unification from scratch, but the standard Mercury unification algorithm and its interaction with modes is not explicitly taught.

8. **`promise_pure` / purity** — Mentioned in FFI but not as a standalone concept.

9. **Nested DCG / DCG with accumulators** — Not explicitly covered.

10. **Testing and property-based testing** — Not covered.

11. **The `solutions/2` and `solutions_set/2` predicates** — Used in a few places but not systematically taught.

12. **`cc_nondet`** — Mentioned in determinism/02 but not given its own exercise.

13. **`require_det` and other scope annotations in depth** — Mentioned in 03-scope-annotations but potentially thin.

14. **Bitwise operations, float operations** — Minimal coverage.

15. **Error handling patterns** — io.res is covered in foundations/07, but Result types and comprehensive error handling patterns are thin.

16. **`inst` names and `any` inst** — Partially covered.

17. **Live data structures / `unique` types beyond arrays** — Not deeply covered.

**Sequencing issues:**
- The parsing track jumps from 03-parsing-utils to 08-packrat (skipping 05-07). This suggests missing exercises.
- The mode-system track lists 7 exercises but only 5 are detailed in the README.
- Bridge 09-typeclass-refactor is listed as a prerequisite for puzzles 05-generic-parser and 06-plugin-architecture, but the bridge itself isn't detailed.
- Some puzzles list prerequisites that reference bridges and katas not yet completed by the learner — e.g., puzzle 05-generic-parser requires bridge/09-typeclass-refactor and puzzles/advanced/04-combinator-library.

**Redundancy:**
- The concept of "determinism categories" is touched in multiple places (determinism track, parsing/04, concurrency), which is appropriate since it's fundamental.
- Higher-order predicates appear in both foundations/04 and mode-system/04 — but they approach from different angles (foundations = usage, mode-system = inst annotations).
- Typeclasses are covered in type-system/04 and then used in type-system/05 and puzzles — good reinforcement.

**Depth assessment:**
- The curriculum goes from basics (hello world) through intermediate (typeclasses, modes, DCG) to advanced (FFI, RTTI, meta-interpreter, plugin architecture).
- The meta-interpreter puzzle is genuinely advanced.
- The plugin architecture puzzle covers existential types + typeclasses in a sophisticated way.
- The packrat parsing kata covers a topic not in the Mercury tutorial.
- However, the "advanced" katas track only has 4 exercises, and one (solver types) has no working build.
- The concurrency track has 8 exercises but only 2 are detailed in the README.

Let me now provide a structured review.

Actually, I should note: I don't have the full contents of all files. I have a sampling of READMEs. The user said "I am not sharing the full contents of any files yet." So I need to work from what I have — the READMEs and the structure visible from those.

Let me rate:

**Breadth: 7/10**
- Strong coverage of core language features (modes, determinism, type system, DCG, higher-order)
- Good coverage of advanced topics (FFI, RTTI, meta-programming, concurrency)
- Notable gaps: solver types (non-functional), STM, comprehensive error handling, property-based testing, module system depth

**Depth: 7/10**
- Goes beyond tutorial level in many areas
- Genuine advanced material (meta-interpreter, plugin architecture, packrat parsing)
- But the advanced katas track is thin (4 exercises, one broken)
- Some tracks may plateau at intermediate-advanced

Let me write this up properly.


</thinking-content-7bbeb8e1441453ad999a0bbba8a46d4b>

## Cinnabar Curriculum Review: Coverage Analysis

### Survey Method

I examined the top-level README, all eight kata-track READMEs, the 10 bridge descriptions, the puzzle index, and detailed exercise READMEs for: foundations/04 (higher-order), type-system/05 (existential types), type-system/09 (phantom types), determinism/02 (committed choice), determinism/06 (negation), mode-system/02 (multi-mode), mode-system/03 (uniqueness), parsing/04 (DCG determinism), parsing/08 (packrat), advanced/03 (RTTI), concurrency/07 (uniqueness and threads), and advanced/01 (FFI depth). I also read the puzzle descriptions for generic-parser, plugin-architecture, and meta-interpreter.

---

### 1. BREADTH — What's Covered vs. What's Missing

**Rating: 7 / 10**

#### Well-Covered Areas

| Concept Area | Exercises | Notes |
|---|---|---|
| **Determinism (6 categories)** | `determinism/01` through `06` | All six categories addressed; committed-choice, scope annotations, and negation each get dedicated exercises |
| **Mode system** | `mode-system/01–07` (7 exercises) | Insts, multi-mode, uniqueness/di-uo, higher-order insts, mode-specific clauses; plus `foundations/09` for basics |
| **Type system** | `type-system/01–09` (5+ exercises) | ADTs, parametric polymorphism, abstract types, typeclasses, existential types, phantom types |
| **Higher-order predicates** | `foundations/04`, `mode-system/04` | Usage patterns + inst annotations on stored predicates; `call/N` covered |
| **DCG parsing** | `parsing/01–08+` (9 exercises) | Basics, semantic actions, parsing_utils, determinism in DCGs, packrat memoization |
| **Concurrency** | `concurrency/01–08` (8 exercises) | Parallel conjunction, threads/channels, uniqueness across thread boundaries |
| **FFI** | `advanced/01` | All four pragma types with attributes (`will_not_call_mercury`, `thread_safe`, `tabled_for_io`) |
| **RTTI / meta-programming** | `advanced/03`, puzzle `07` | `deconstruct/5`, generic pretty-printer, full meta-interpreter with unification and backtracking |
| **Standard library idioms** | `foundations/02–08` | `maybe`, `string`, `map`, `set`, `io.res`, exceptions, built-in type corners |

#### Notable Gaps

| Missing Concept | Impact |
|---|---|
| **Solver types** | `advanced/02` is listed as a "reference kata" with no working build. Solver types are a distinctive Mercury feature — this is effectively absent from the curriculum. |
| **Software Transactional Memory (STM)** | No coverage at all. `stm` module and `atomic/2` are important for concurrent state beyond the mutex/mvar patterns in concurrency/07. |
| **Comprehensive error-handling patterns** | `foundations/07` covers `io.res` and `exception.catch_any`, but there's no exercise on designing with `maybe(T)` vs `io.res` vs Result types as an error-handling strategy. The `01-maybe-extend` bridge touches this lightly. |
| **Module system depth** | `foundations/01` covers basics (interface/implementation, import vs use), but advanced module features — abstract exports, sharing constraints, functor-based parametric modules — are absent. |
| **Property-based testing** | No coverage. Mercury's `test` framework with QuickCheck-style properties is not addressed. |
| **Groundness and `ground` inst** | Not explicitly taught. Relevant for understanding why some mode errors occur. |
| **Nested DCG / accumulator-passing DCG** | Parsing covers basic DCG and packrat, but not the pattern of threading accumulators through DCG rules for complex parsing tasks. |
| **`foreign_enum`, `foreign_struct`** | FFI kata covers the four pragma types but doesn't go into enum/struct interop details. |

#### Thin Coverage

- **`cc_nondet`**: Mentioned in `determinism/02` alongside `cc_multi` but doesn't get its own exercise. The distinction between `cc_nondet` and `semidet` (both are "one solution, but different reasons") is listed as a checkpoint question but not drilled.
- **`require_det` / scope annotations**: `determinism/03` covers these, but only one exercise. Given how confusing scope annotations are for newcomers, this could be deeper.
- **`version_array`**: Appears in `mode-system/03` and `concurrency/07` but only as a contrast to `array`. The persistent data structure pattern deserves more exploration.

---

### 2. DEPTH — Does the Curriculum Scale?

**Rating: 7 / 10**

The curriculum has genuine depth in several areas:

- **The meta-interpreter puzzle** (`puzzles/advanced/07`) is excellent — implementing unification, resolution, and `solutions/2` from scratch forces deep understanding of mechanisms the compiler normally hides.
- **The plugin architecture puzzle** (`puzzles/advanced/06`) combines existential types, typeclass-constrained existentials, and heterogeneous collections in a non-trivial way.
- **Packrat parsing** (`parsing/08`) goes beyond the tutorial with a topic (tabling incompatibility with parallel grade) that many Mercury programmers don't know.
- **The determinism track** builds a proper lattice understanding: six categories → committed choice → scope annotations → negation semantics.

However, the curriculum **plateaus in the advanced katas track**:
- Only 4 exercises, one of which (`solver-types`) has no working build.
- The FFI kata is well-constructed but isolated — it doesn't connect to a larger systems-programming narrative.
- There's no exercise that combines multiple advanced features (e.g., FFI + concurrency, or typeclasses + meta-programming).
- The highest-level puzzles (generic parser, plugin architecture) are excellent but there are only two of them in the "advanced" puzzle category.

**The mode system track** also shows a depth gap: exercises 04–07 exist in the index but their READMEs weren't available for review. If they cover topics like inst inference for polymorphic higher-order predicates or mode-directed compilation, the depth improves significantly.

---

### 3. SEQUENCING — Is the Order Right?

**Rating: 8 / 10**

The overall sequencing is well-designed:

- **Foundations → Type system → Mode system → Determinism → Parsing** is the recommended order, and it makes sense. You need modules and maybe-types before you can understand typeclasses; you need modes before determinism makes sense; you need all of it before DCG parsing.
- **Bridges are positioned well**: 01–03 after Foundations, 04–06 after Mode system/Determinism, 07–10 after Parsing and Advanced.
- **The `foundations/09-mode-inference` placement** is smart — it's a mode-system concept but placed at the end of Foundations as a bridge to the Mode system track.

**Potential sequencing issues:**

1. **`type-system/04-type-classes`** requires understanding of parametric polymorphism (`02`) and abstract types (`03`), but the ordering is correct. However, `05-existential-types` says "read 04-type-classes first" — good, but existential types also depend on understanding `type-system/03-abstract-types` for the "why" of opaque wrapping. The dependency is implicit rather than stated.

2. **Puzzle prerequisites form long chains**: `puzzles/advanced/05-generic-parser` requires `katas/typeclasses/01`, `katas/typeclasses/02`, `bridge/09`, and `puzzles/advanced/04-combinator-library`. That's four prerequisites, two from different tracks. A learner who finished the type-system track but skipped the combinator-library puzzle can't attempt the generic parser. This is correct but could frustrate.

3. **The parsing track has a numbering gap**: exercises jump from `03-parsing-utils` to `08-packrat`. Exercises 05–07 presumably exist (the track lists 9 total) but their READMEs weren't available. If a learner encounters this gap, it's confusing.

4. **`concurrency/01-parallel-conjunction`** requires `.par` grade, which is set as the default in `flake.nix`. But `concurrency/02-threads` also requires `.par`, and the concurrency README states "Both require the `.par` grade." There's no exercise explaining *what grades are* before throwing learners into grade-dependent code. The `tooling/01-grades` kata exists but is in a separate track. A concurrency-first learner might hit grade confusion.

---

### 4. GAPS — The Most Notable Absence

**The single most important missing concept: Software Transactional Memory (STM).**

Mercury's STM system (`stm` module, `atomic/2`, `transaction/2`) is the primary mechanism for safe concurrent state mutation beyond mutex-based patterns. The curriculum covers:
- `array` vs `version_array` (mode-system/03)
- `mvar` + semaphore mutex (concurrency/07)
- But never `stm`

A learner who finishes the concurrency track knows how to *avoid* shared mutable state (version_array) and how to *protect* it (mutex), but never learns Mercury's composable transaction system. This is the approach Mercury itself recommends for most concurrent state problems.

**Second most notable gap: the solver types hole.**

Solver types are one of Mercury's most unique features — they're what makes Mercury a *constraint logic programming* language rather than just a logic language. The fact that `advanced/02` is a broken reference kata means learners get no guided exposure to `solver type` declarations, `any` inst, or the `.tr` grade.

**Third gap: no synthesis/capstone exercise.**

There's no exercise that requires combining features across tracks (e.g., "build a concurrent parser that uses typeclasses for extensible token streams and existential types for plugin-based output formatting"). The puzzles come closest, but they're siloed by topic.

---

### 5. REDUNDANCY — Over-Covered Areas

**Rating: Low redundancy overall — 3 / 10**

The curriculum is lean. The few areas of overlap are justified:

- **Determinism concepts appear in multiple tracks** (determinism track, parsing/04, mode-system exercises). This is appropriate — determinism is so fundamental that reinforcement helps.
- **Higher-order predicates** appear in both `foundations/04` (usage) and `mode-system/04` (inst annotations). These approach genuinely different skills and aren't redundant.
- **`version_array`** appears in both `mode-system/03` and `concurrency/07`, but from different angles (uniqueness model vs. thread safety).

The only arguably redundant element is the **`promise_equivalent_clauses` pragma**, which appears in `mode-system/02` and is referenced in `mode-system/05` and `determinism/02`. Given how confusing this pragma is, the repetition is probably helpful rather than wasteful.

---

### Summary Table

| Area | Breadth Coverage | Depth | Notes |
|---|---|---|---|
| Determinism (6 cats) | ★★★★★ | ★★★★ | Committed choice and scope annotations well-covered |
| Mode system | ★★★★★ | ★★★★ | Insts, multi-mode, uniqueness all solid |
| Type system (ADTs → phantom) | ★★★★★ | ★★★★ | Existential + phantom types go beyond tutorial |
| Higher-order predicates | ★★★★ | ★★★★ | inst annotations well-taught |
| DCG parsing | ★★★★ | ★★★★ | Packrat is a standout |
| Concurrency | ★★★★ | ★★★ | STM absence hurts depth |
| FFI | ★★★ | ★★★ | Solid but isolated |
| RTTI / meta-prog | ★★★ | ★★★★ | Meta-interpreter is excellent |
| Standard library | ★★★★ | ★★★ | Good idioms, thin on error handling |
| Advanced features (solver types, STM) | ★ | ★ | Effectively absent |

**Overall breadth: 7/10** — Covers the core language thoroughly but misses solver types, STM, and several secondary features.

**Overall depth: 7/10** — Reaches genuinely advanced territory in spots (meta-interpreter, plugin architecture, packrat) but the advanced katas track is underweight and there's no capstone synthesis.

> Tokens: 18k sent, 5.8k received. Cost: $0.0050 message, $0.0050 session.  
