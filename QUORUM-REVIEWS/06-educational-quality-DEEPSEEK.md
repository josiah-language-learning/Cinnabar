# Review 06 — Educational Quality

**Reviewer:** DEEPSEEK
**Date:** 2026-06-22

## Score: 7/10

This is the most important review dimension. The curriculum exists to teach Mercury and declarative programming. Its educational quality determines whether a learner who completes it can read, write, and debug Mercury code independently.

I evaluated the curriculum against established learning science principles: scaffolding, spaced repetition, feedback mechanisms, cognitive load management, transfer-appropriate processing, and metacognitive support. The project has several genuinely innovative features and several significant gaps.

## What works exceptionally well

### 1. The four-format ladder (koan → kata → bridge → puzzle)

Each exercise format has a distinct pedagogical job, and they compose into a genuine progression:

| Format | Job | Cognitive load | Feedback | Transfer |
|---|---|---|---|---|
| **Koan** (80) | Build error literacy | Very low — 25-60 lines, one error | Immediate: compiler error message | Transfers to debugging real Mercury code |
| **Kata** (71) | Build mechanical fluency | Low — one concept, fill stubs | Compile + run (if test script exists) | Transfers to writing Mercury from scratch |
| **Bridge** (12) | Practice design patterns | Medium — extend working code, multiple tasks | Compile + expected output | Transfers to extending existing codebases |
| **Puzzle** (21) | Force synthesis | High — design from scratch, multiple concepts | Self-check against solution | Transfers to real-world Mercury development |

This progression is correctly ordered by cognitive load and correctly targets different transfer contexts. The koans target the single biggest frustration for new Mercury programmers (inscrutable error messages) and address it at the lowest possible cognitive load: a 25-line file with one deliberate mistake. This is brilliant instructional design.

**Learning science alignment:** The ladder implements **successive approximation** (Bloom's mastery learning with progressively more complex tasks) and **transfer-appropriate processing** (each format's practice environment matches its target application context).

### 2. The 80-error koan library

The koans are the project's most innovative feature. No other Mercury resource — and few language curricula in any language — builds compiler-error literacy at this scale. Key design decisions that make them effective:

- **Minimality:** each koan is 25-60 lines with exactly one deliberate error. The learner's cognitive load is spent on understanding the error, not on navigating the code.
- **One-to-one mapping:** each koan maps to exactly one compiler error category. No combination errors, no cross-cutting failures. This makes the `.err` snapshot work as a reliable test oracle.
- **`.err` snapshot verification:** the CI checks that every diagnostic phrase in the snapshot appears in the actual compiler output. This catches compiler version drift (when error messages change between Mercury releases).
- **Range of error types:** parser errors, type errors, mode errors, determinism errors, typeclass errors, existential type errors, FFI errors, solver type errors. The 71 koans with `.m` files cover most error categories a Mercury programmer encounters.

**Learning science alignment:** The koans implement **example-based learning** with **error-driven learning** — the learner sees a concrete error, reads the error message, and forms a mental model of "what kind of code produces this error pattern." This is more effective than reading a list of error messages because it provides a specific program context for each error.

### 3. `COMPILER-LESSONS.md` (1821 lines)

This file documents real compiler errors encountered during the project's development, with symptoms, causes, and fixes. It serves as an **annotated error compendium** that complements the koans: the koans provide the minimal program, COMPILER-LESSONS.md provides the narrative of encountering the error in a real development context.

Value: the file documents errors that the koans deliberately create but also errors that arise accidentally during development (wrong import, wrong grade flag, module resolution failure, etc.). These "accidental" errors are pedagogically valuable — they teach debugging strategies that the koans cannot.

**Missing:** A table of contents. 1821 lines with 8 major sections and no navigation means the learner must search by error phrase or scroll blindly. A TOC with anchor links would make this browsable.

### 4. Bridge solution READMEs

Every bridge solution README adds pedagogical value beyond what the main README provides. The solution READMEs are consistently the best educational content in the project because they:

- Explain **why** a design choice was made (not just what the fix is)
- Show **multiple approaches** and compare trade-offs (bridge 04 shows 3 approaches for committed-choice first-solution)
- Include **compiler error reproductions** (bridge 07, bridge 08, bridge 12)
- Document **real-world gotchas** (bridge 10: `busy_wait` TCO'd away, bridge 06: record-of-functions inst limitation)
- End with **design questions** that prompt metacognition (bridge 05 has 3 design questions, bridge 09 could benefit from this pattern)

**Learning science alignment:** Solution READMEs model **expert thinking** — they show not just the final answer but the reasoning process that produced it. This is more effective than showing final code because it transfers to new problems.

### 5. The reactivation track's predict-verify method

Foundations 00-reactivation uses a predict-verify method: read the README, write down what you expect the program to do, then open the source code and note what surprised you. The README explicitly says: "The gap between prediction and reality is the actual learning. Passive reading closes no gaps."

This is grounded in learning science: the **prediction error** or **surprise signal** enhances memory formation. When a learner predicts "this program will use an if-then-else" and finds a case/switch instead, the surprise creates a stronger memory trace than passive reading would.

**Downside:** The method is only used in 00-reactivation (7 micro-exercises). The remaining 170+ exercises use read-then-code. The predict-verify method is never mentioned again. A learner who found it useful for reactivation may not generalize it to other tracks.

## What needs improvement

### 1. No test scripts for most exercises (critical gap)

Only a minority of katas have `runtests` scripts. Foundations/12-io-patterns has one. Most katas have no automated verification. The learner's only feedback is "does it compile?" and "does the output look right?"

**Why this matters:** Without tests, the learner can write code that:
- compiles but produces wrong output (e.g., accidentally reversing a list instead of sorting it)
- compiles but teaches the wrong lesson (e.g., using `++` instead of cons for accumulation)
- produces correct output for the test case but fails on edge cases the learner didn't consider

The missing test scripts are the single biggest educational quality gap. They are the feedback mechanism that closes the learning loop.

**Recommendation:** Create a `runtests` script for every kata. The script can be simple: compile, run, check output against expected string. Foundations/12-io-patterns's script is a 15-line shell script — low effort, high impact.

### 2. No time estimates (medium gap)

No exercise in the curriculum has a time estimate. After reading all 184 READMEs, I can confirm this is universal. Self-directed learners (the target audience — see START-HERE.md's three paths) need to plan their sessions. Without estimates, a learner cannot distinguish a 15-minute kata from a 2-hour puzzle.

**Recommendation:** Add `**Time:** ~30 min` to each exercise README. The bridge index (`bridge/README.md`) would benefit from a "Time" column. Even approximate labels (short/medium/long) would help.

### 3. No worked examples (medium gap)

Every kata presents the concept textually and then asks the learner to write code. There are no **worked examples** — complete code with line-by-line annotations showing *how* the concept maps to Mercury code.

Example: the determinism kata 01 (six categories) shows code snippets for `det`, `semidet`, `multi`, `nondet`, `erroneous`, and `failure`:

```mercury
:- pred safe_head(list(T)::in, T::out) is semidet.
safe_head([H | _], H).
```

But there's no annotation explaining WHY the mode is `in`/`out`, WHY the determinism is `semidet`, WHAT would change if `det_head` existed (it would need a different determinism). A worked example would annotate every line of `safe_head` with the reasoning.

**Recommendation:** Add a "Worked Example" block to the first kata in each track. Show the solution with extensive annotations. This is higher effort than other improvements but would significantly benefit learners who learn best by example.

### 4. No recall/review mechanism (medium gap)

The curriculum is linear: work track 1, then track 2, then track 3. Nothing tells the learner to revisit earlier material. Nothing provides spaced repetition (retrieval practice with increasing intervals). Nothing tests long-term retention.

**Recommendation:** Add a "Review Questions" section to each track index README. These would be conceptual questions that draw on material from earlier exercises in the track. For example, the determinism track index could ask: "Can you name all 6 determinism categories and give an example of each?" — referencing kata 01 which the learner completed earlier.

### 5. Cross-track dependencies undocumented (medium gap)

Some exercises reference material from other tracks:
- Determinism katas reference concurrency concepts (committed choice for thread spawn)
- Bridges reference puzzles (bridge 10: `puzzles/concurrent/02-pipeline`)
- Puzzles reference bridges (advanced puzzles: bridge 08, bridge 09)

There is no "recommended cross-track order" document. A learner following START-HERE.md's track-by-track order might encounter references to material they haven't seen.

**Recommendation:** Add a "Prerequisites" line to each exercise that lists both intra-track and cross-track dependencies. Bridge index already does this ("After:" column); extend the pattern to kata track indexes.

### 6. Foundations track heading convention (low gap but pervasive)

The foundations track uses bold inline text (`**Concept:** ...`) instead of proper section headings. This affects 13 kata READMEs. The rest of the project uses section headings. Standardizing would improve visual scanning and consistency.

### 7. Inconsistent "Why Mercury" coverage (low gap but motivational)

The determinism track has "Why Mercury" in 7/7 katas. The type system track has it in 0/10. A learner who goes from determinism (where every exercise explains why Mercury's approach matters) to type system (where no exercise does) will notice the motivational framing drop off. The puzzles (21/21 with Why Mercury) show it's possible to write Why Mercury for any concept — the type system track just hasn't done it yet.

## Track-by-track educational quality

| Track | Score | Strengths | Weaknesses |
|---|---|---|---|
| Foundations | 6/10 | Strong 12-io-patterns, reactivation predict-verify method | No section headings, 1/13 with Why Mercury, stale numbering, sparse tests |
| Type system | 8/10 | Comprehensive (ADTs→GADTs), excellent GADT approximations kata | No Why Mercury, 4 stale koan refs, no tests |
| Mode system | 9/10 | Deepest resource on modes, func-vs-pred kata, uniqueness coverage | No Why Mercury (except func-vs-pred) |
| Determinism | 10/10 | Most polished track. Why Mercury 7/7. All exercises excellent quality. | No tests in some katas |
| Parsing | 8/10 | 9 katas DCG→desugar, strong left-recursion kata | No Why Mercury |
| Tooling | 7/10 | Property-based testing, grades reference | No debugging test exercise, grades reference-only |
| Concurrency | 8/10 | STM unique, granularity kata, 3 documented real bugs | Some katas lack What-to-build clarity |
| Advanced | 7/10 | FFI depth, mutable state kata | Solver types non-buildable, no FFI bridge |
| Bridges | 9/10 | Solution READMEs best content, 11/12 Why Mercury | Bridge 10 missing Why Mercury, solution/README competing claim |
| Puzzles | 9/10 | All 21 Why Mercury, all excellent, advanced puzzles challenging | 2 stale cross-refs, no time estimates |

## Learning science alignment scorecard

| Principle | Score | Evidence |
|---|---|---|
| Scaffolding (increasing complexity) | 9/10 | 4-format ladder correctly ordered |
| Feedback (timely, specific) | 4/10 | Koans provide immediate compiler feedback; most katas don't test |
| Spaced repetition | 2/10 | No review exercises, no interleaving |
| Metacognitive support | 7/10 | Checkpoint criteria in many exercises; predict-verify in reactivation |
| Cognitive load management | 8/10 | Koans are 25-60 lines; katas are single-concept; minimal files |
| Transfer-appropriate processing | 9/10 | Each format targets a different transfer context |
| Worked examples | 3/10 | Bridge solution READMs are partial worked examples; katas lack them |
| Motivation / relevance framing | 7/10 | "Why Mercury" is excellent where it exists (50% of exercises) |

## Summary

| Sub-dimension | Score (1-10) |
|---|---|
| Four-format ladder | 10 |
| Koan error literacy | 10 |
| COMPILER-LESSONS.md | 10 |
| Bridge solution READMEs | 10 |
| Predict-verify method | 9 |
| Metacognitive checkpoints | 7 |
| "Why Mercury" motivation | 7 |
| Test/feedback coverage | 4 |
| Worked examples | 3 |
| Time estimates | 0 |
| Spaced repetition / review | 2 |
| Cross-track dependency docs | 3 |

**Overall educational quality score: 7/10**

The curriculum's educational design has genuine breakthroughs — the four-format ladder, the 80-error koan library, the predict-verify method in reactivation, and the bridge solution READMEs are all innovations in Mercury pedagogy. The gaps are in basic learner-support features: tests, time estimates, worked examples, review exercises. These are implementation effort rather than design problems. The pre-alpha status excuses the absence but the roadmap should prioritize tests (P0) and time estimates (P1).
