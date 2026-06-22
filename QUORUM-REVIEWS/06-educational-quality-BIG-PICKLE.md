# Review 06 — Educational Quality

**Reviewer:** BIG-PICKLE
**Date:** 2026-06-22

## Overall Assessment

This is the most important dimension. The curriculum exists to teach Mercury and declarative programming, and its educational quality determines whether it succeeds. This review evaluates scaffolding, sequencing, feedback mechanisms, cognitive load management, and alignment with learning science principles.

---

## What the Project Does Exceptionally Well

### 1. The kata → bridge → puzzle → koan progression

The four exercise types form a genuine learning progression:

- **Koans** (80 exercises): minimal programs that trigger specific compiler errors. The learner reads the error, reads the koan, and maps the error pattern to the code that caused it. This builds *error literacy* — the ability to read a Mercury compiler error and know what it means.

- **Katas** (71 exercises): single-concept drills. Fill in the stub, make the test pass. The learner practices one concept repeatedly until it's automatic.

- **Bridges** (12 exercises): start with working code, extend it in defined ways. The learner practices the design decisions that puzzles require but with less blank-page friction.

- **Puzzles** (21 exercises): open-ended problems. No single target technique. The learner must design a solution from scratch.

This four-tier progression is exactly right for a concept-heavy language like Mercury. The koans build error literacy (the single biggest frustration for new Mercury programmers). The katas build mechanical fluency. The bridges teach design patterns. The puzzles integrate everything.

**Educational design:** 10/10 — this tiered structure is the project's most important contribution to Mercury pedagogy.

### 2. Predict-verify method in the reactivation track

Foundations 00-reactivation uses a predict-verify method: read the README, write down your prediction, then read the code and note what surprised you. This is grounded in learning science (the "prediction error" or "surprise" signal is known to enhance memory formation). The reactivation track's README explicitly addresses passive reading: "Passive reading closes no gaps."

**Educational design:** 10/10 — this is better than any other Mercury tutorial.

### 3. "Checkpoint" criteria in most exercises

Many exercise READMEs end with a "Checkpoint" section that lists what the learner should be able to *state* (not just do). This is a metacognitive prompt — it moves the learner from "I made the tests pass" to "I can explain the concept."

For example, determinism kata 02's checkpoint:
- "Exercise 1: `first_string` always commits to `"apple"`
- Exercise 2: `main` declared as `det` compiles correctly
- Exercise 3: `promise_equivalent_solutions` used correctly
- You can explain: what is the difference between `cc_nondet` and `semidet`?"

The last line is the important one — it tests *understanding*, not just completion.

**Educational design:** 9/10 — not all exercise READMEs have this (foundations 05-map, 06-set lack it), and the checkpoint content is sometimes too tied to the specific task rather than the general concept. But the pattern is strong where it exists.

### 4. "Why Mercury" as a consistent framing device

Every exercise starts by explaining why Mercury's approach to the concept is distinctive. This is motivational framing — it answers "why should I care about this Mercury-specific thing?" before the learner invests effort. The pattern is consistent: name the familiar pain point in other languages → show Mercury's type-level solution → let the compiler enforce it.

The "Why Mercury" section in determinism kata 01 is a perfect example: "in most languages determinism is a runtime property... In Mercury it is a compile-time contract." A learner who reads that understands why the concept matters before writing any code.

**Educational design:** 9/10 — only bridge 10 is missing this, and the foundations track's "Why Mercury" sections are less thorough than the determinism/advanced tracks'.

### 5. `COMPILER-LESSONS.md` (1821 lines)

This file is a living document of compiler error messages encountered during development. Each entry includes the error, what caused it, and how to fix it. This is an extraordinary resource — it's essentially a field guide to Mercury error messages, accumulated from real development experience.

The koans provide the minimal program for each error; COMPILER-LESSONS.md provides the narrative of encountering and resolving the error in a real context. The two resources complement each other.

**Educational design:** 10/10 — no other Mercury resource does this.

---

## What Needs Improvement

### 1. No feedback mechanism for learners

The curriculum has no built-in feedback mechanism. There are:
- No self-check questions ("Why does `&` require `det`?")
- No answer keys for the checkpoint questions
- No way to verify understanding beyond "does it compile" and "does the test pass"

For tracks that don't have test scripts (most katas don't), the only feedback is "did `mmc --make` succeed?" and "does the output look right?" This is insufficient for a self-directed learner — they may produce code that compiles but teaches the wrong lesson.

**Fix:** The highest-leverage improvement would be adding a `runtests` script to every kata (like foundations 12-io-patterns does). The script should compile, run, and check output against expected values. Failing that, at minimum the Checkpoint questions should have answers in a `solutions/CHECKPOINTS.md` file.

### 2. Reactivation track's method is not propagated

The predict-verify method is brilliant for the reactivation track but is never mentioned again. The remaining 170+ exercises use read-then-code. The learner may not generalize the predict-verify strategy to other tracks.

**Fix:** Add a one-paragraph note to the kata track index README: "If you find yourself reading passively, try the predict-verify method from the reactivation track — write down your expectation before reading the starter code." This would propagate the learning strategy without changing every exercise.

### 3. No worked examples / "see the pattern before you drill it"

Every kata presents the concept textually and then asks the learner to write code. There are no worked examples — complete code with annotations showing *how* the concept maps to code. The bridges provide this (working code that you extend), but the katas are more "here's the concept, go write it."

For example, mode-system kata 09 (func-vs-pred) presents the concept with textual explanations and code snippets, then expects the learner to implement `safe_div`, `checked_div`, and `divides`. A worked example showing `safe_head` (from the concept section) with annotations about why the mode is `in`/`out`, why the determinism is `semidet`, and what would change if it were `det` — this would model the thinking process for the learner.

**Fix:** Add a "Worked Example" block to the first kata in each track (or the hardest kata in each track). Show the solution with extensive annotations. This is more effective than showing just the final code in a solution directory.

### 4. The 00-reactivation numbering is confusing

The reactivation track is numbered `00-reactivation`, with sub-exercises `01-hello-world` through `07-zookeeper-puzzle`. But it lives inside `foundations/00-reactivation/`, which means the full path is `katas/foundations/00-reactivation/01-hello-world/`. This creates ambiguity: is `01` a reference to the foundations track entry (modules) or the reactivation sub-exercise (hello-world)?

The track index README correctly lists foundations entries as `00-reactivation`, `01-modules`, etc., but the START-HERE.md points to `foundations/00-reactivation` as the first stop. A learner who reads `foundations/README.md` sees `00-reactivation/` as the first entry and `01-modules/` as the second, and might think they need to complete all of `00-reactivation` before starting `01-modules` — which is actually correct (the track says "work them in order").

**Fix:** Either rename `00-reactivation` to `01-reactivation` and shift modules to `02` (consistent numbering with no zero), or keep the zero but document it explicitly: "`00-reactivation` is a warm-up. Skip it if you're an experienced Mercury programmer returning after a gap." The current ambiguity is minor but avoidable.

### 5. Scaffolding for bridges is inconsistent

Some bridges start with very simple extensions and build up (bridge 01: add timeout, then validation, then format; bridge 07: add line numbers, then error reporting, then edge cases). Others jump to the hard part immediately (bridge 04: first solution, then parallel search, then parameterized early exit — the parallel search is a significant leap from the if-then-else committed choice).

Bridges 07 and 08 are the best-modeled for scaffolding — each task builds clearly on the previous one, and the complexity increase is manageable. Bridges 04 and 06 could use more intermediate steps.

### 6. No estimated time on task

As noted in the README quality review, no exercise tells the learner how long it should take. This is a significant gap for self-directed learners who need to plan their sessions. A 30-minute bridge and a 2-hour puzzle look identical on the page.

**Fix:** Add `**Time:** ~30 min` to each exercise README. The bridge index table (`bridge/README.md`) would benefit from a "Time" column alongside the existing "After" column.

### 7. Test scripts are not uniformly present

Foundations kata 12 (IO patterns) has a `runtests` script. The determinism katas have test scripts in some cases. But most katas don't — the learner writes code and the only verification is "does it compile?" The tests are the most important feedback mechanism. Without them, the learner can write code that accidentally does the wrong thing (e.g., reversing a list instead of folding it) and never know.

**Fix:** Make `runtests` a standard fixture in every kata directory. The script can be simple (compile, run, check output) — it doesn't need to be a full test framework.

---

## Advanced Pedagogical Notes

### Spacing and interleaving

The curriculum is organized by track (foundations, determinism, etc.), which means concepts within a track are *blocked* — all determinism exercises are in the determinism track, all mode exercises in the mode track. This is the natural way to organize a curriculum, but learning science suggests that *interleaving* (mixing different concepts in practice) improves long-term retention.

The reactivation track (00-reactivation/07-zookeeper-puzzle) is the only exercise that interleaves multiple concepts (modes, determinism, negation). The bridges also interleave somewhat (they draw on multiple katas). But the core kata structure blocks concepts.

**Observation only** — restructured interleaving is a major curriculum design change that's inappropriate for pre-alpha. The blocking is fine for initial learning. Interleaving is a v2 concern.

### Transfer-appropriate processing

The koans teach error recognition, which transfers well to debugging. The katas teach mechanical fluency, which transfers well to writing code from scratch. The bridges teach design patterns, which transfer well to extending existing code. The puzzles teach integration, which transfers well to real-world programming. The progression is well-aligned with the transfer-appropriate processing principle.

---

## Summary

| Dimension | Score (1-10) |
|-----------|-------------|
| Tiered progression (koan/kata/bridge/puzzle) | 10 |
| Predict-verify method | 10 |
| Checkpoint criteria | 9 |
| "Why Mercury" framing | 9 |
| `COMPILER-LESSONS.md` value | 10 |
| Feedback mechanisms (tests) | 4 |
| Worked examples | 3 |
| Time estimates | 0 |
| Scaffolding within exercises | 7 |
| Error literacy (koans) | 10 |

**Overall educational quality score: 8/10**

The project's educational design is genuinely innovative in several dimensions (four-tier progression, 80-error koan library, predict-verify method, COMPILER-LESSONS.md). These are contributions to Mercury pedagogy that didn't exist before this project. The gaps (missing test scripts, no time estimates, no worked examples) are all straightforward to address and would significantly improve the learner experience. The project is pre-alpha and the educational foundations are sound; the missing pieces are mostly implementation effort rather than design problems.
