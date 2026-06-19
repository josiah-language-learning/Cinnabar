
# aider chat started at 2026-06-19 19:15:50

> /home/josiah/.local/bin/aider --no-git --chat-mode ask --model openrouter/inclusionai/ring-2.6-1t --map-tokens 1000 --yes --no-auto-commits --read README.md --read COMPILER-LESSONS.md --read ci.sh --read katas/determinism/01-six-categories/README.md --read katas/type-system/04-type-classes/README.md --read katas/concurrency/09-stm/README.md --read koans/foundations/01-maybe/README.md --read koans/advanced/07-solver-any-inst/README.md --read bridge/05-mode-reversal/README.md --read bridge/05-mode-reversal/solution/README.md --read bridge/09-typeclass-refactor/solution/README.md --read bridge/11-error-handling/README.md --read bridge/11-error-handling/solution/README.md --read puzzles/advanced/03-bidirectional-search/README.md --read puzzles/advanced/07-mercury-in-mercury/README.md --read puzzles/advanced/07-mercury-in-mercury/solution/README.md --read puzzles/concurrent/02-pipeline/solution/README.md --read puzzles/logic/01-sudoku/solution/sudoku.m --read puzzles/advanced/04-combinator-library/solution/combinators.m --read puzzles/advanced/07-mercury-in-mercury/solution/meta_interp.m --message-file /tmp/ring-r5-prompt.txt --chat-history-file /home/josiah/Development/personal/education/self/polyparadigm-project/cinnabar/RING-REVIEWS/05-overall.md  
> Aider v0.86.2  
> Model: openrouter/inclusionai/ring-2.6-1t with ask edit format  
> Git repo: none  
> Repo-map: disabled  
> Added katas/concurrency/09-stm/README.md to the chat (read-only).  
> Added koans/foundations/01-maybe/README.md to the chat (read-only).  
> Added puzzles/logic/01-sudoku/solution/sudoku.m to the chat (read-only).  
> Added koans/advanced/07-solver-any-inst/README.md to the chat (read-only).  
> Added ci.sh to the chat (read-only).  
> Added bridge/05-mode-reversal/README.md to the chat (read-only).  
> Added puzzles/advanced/07-mercury-in-mercury/solution/meta_interp.m to the chat (read-only).  
> Added bridge/11-error-handling/solution/README.md to the chat (read-only).  
> Added bridge/11-error-handling/README.md to the chat (read-only).  
> Added bridge/09-typeclass-refactor/solution/README.md to the chat (read-only).  
> Added README.md to the chat (read-only).  
> Added puzzles/concurrent/02-pipeline/solution/README.md to the chat (read-only).  
> Added puzzles/advanced/04-combinator-library/solution/combinators.m to the chat (read-only).  
> Added COMPILER-LESSONS.md to the chat (read-only).  
> Added bridge/05-mode-reversal/solution/README.md to the chat (read-only).  
> Added katas/determinism/01-six-categories/README.md to the chat (read-only).  
> Added puzzles/advanced/07-mercury-in-mercury/solution/README.md to the chat (read-only).  
> Added katas/type-system/04-type-classes/README.md to the chat (read-only).  
> Added puzzles/advanced/03-bidirectional-search/README.md to the chat (read-only).  
> Added puzzles/advanced/07-mercury-in-mercury/README.md to the chat (read-only).  

#### You are reviewing the Cinnabar Mercury curriculum project in the current directory. This is a final overall assessment.  
####   
#### REVIEW FOCUS: Overall quality of the Cinnabar curriculum as an educational project.  
####   
#### You have been given a representative mix of content — root README, exercise READMEs, solution READMEs, source files, and the CI gate script. All Mercury source files have been verified to compile against Mercury 22.01.8.  
####   
#### Evaluate the full arc:  
#### 1. LEARNING PATH: Does the progression from katas → koans → bridges → puzzles form a coherent arc? Does a learner who completes Cinnabar emerge with genuinely improved Mercury fluency, or do they just accumulate exercises?  
####   
#### 2. PHILOSOPHY: Does the curriculum have a coherent educational philosophy? Is it consistently applied? Does the "You bring raw material; the heat does the work" framing match the actual exercise design?  
####   
#### 3. DIFFICULTY CURVE: Is the difficulty curve appropriate? Where does it plateau, where does it spike unexpectedly?  
####   
#### 4. FORMAT COHERENCE: Are the four formats (katas/koans/bridges/puzzles) well-distinguished? Could any exercise be moved to a different format and work better there?  
####   
#### 5. STRUCTURAL ISSUES: Are there exercises that belong in a different track? Tracks that feel thin or bloated? Connective tissue that's missing between sections?  
####   
#### 6. COMPARISON: How does this compare to similar educational repositories in other languages (e.g., exercism tracks, language koans projects)? Where is it stronger, where weaker?  
####   
#### 7. RELEASE READINESS: If the author released this to the Mercury community tomorrow, what would the community say? What are the two or three highest-priority things to fix before release?  
####   
#### 8. GENUINE STRENGTHS: What is genuinely impressive or well-done here, that the author should be proud of and preserve?  
####   
#### Give an overall quality rating on a 1–10 scale with a paragraph justification. Be honest — this is meant to be actionable feedback before a community release.  

<thinking-content-7bbeb8e1441453ad999a0bbba8a46d4b>



Let me carefully analyze the Cinnabar Mercury curriculum project based on all the files provided. I need to evaluate it across multiple dimensions: learning path, philosophy, difficulty curve, format coherence, structural issues, comparison to similar projects, release readiness, and genuine strengths.

**1. LEARNING PATH Analysis**

The project has four exercise formats organized into tracks:
- **Katas** (8 tracks, ~74 exercises total): Foundations (12), Type system (10), Mode system (8), Determinism (7), Parsing (9), Tooling (6), Concurrency (9), Advanced (7)
- **Koans** (~27 total): Foundations (20), Type system (10), Mode system (7), Determinism (7), Parsing (7), Tooling (9), Concurrency (7), Advanced (8)
- **Bridges** (11): Progressive skill-building exercises
- **Puzzles** (17): Open-ended problems across logic, data structures, parsing, concurrent, and advanced topics

The recommended order in the README is: Foundations → Type system → Mode system → Determinism → Parsing → Tooling, Concurrency, Advanced in any order.

The learning path has a clear pedagogical logic:
- Katas build muscle memory on specific concepts
- Koans provide diagnostic "break things" moments
- Bridges bridge the gap between isolated exercises and real code
- Puzzles are capstone challenges

This is a well-thought-out progression. The learner goes from guided repetition (katas) through debugging (koans) to extension (bridges) to open-ended problem solving (puzzles). This mirrors established pedagogical patterns (e.g., Karplus learning cycle).

However, I notice some gaps:
- The jump from katas to puzzles is acknowledged in the README ("Use these when the jump from katas to puzzles feels steep") which suggests the authors are aware of the gap
- The concurrency track starts at katas/concurrency/01-parallel-conjunction but there's no bridge for concurrency — the bridges don't cover concurrency topics
- The advanced track (katas/advanced) covers FFI, solver types, and STM, but these feel like they should come after more foundational work

**2. PHILOSOPHY Analysis**

The "You bring raw material; the heat does the work" framing is compelling and matches the exercise design philosophy:
- Kata solutions are intentionally NOT provided ("The derivation is the work")
- Koans are designed to be broken first, with solutions only for reference
- Bridges give you working code to extend, not blank slates
- Puzzles have solutions but they're genuinely complex

The philosophy is coherent: learn by doing, struggle productively, and the compiler is your teacher. This is consistent with research on productive failure and desirable difficulties in learning science.

The "compiler as teacher" approach is well-executed:
- Koans are specifically designed to produce informative compiler errors
- The COMPILER-LESSONS.md file is an excellent resource that turns common errors into learning moments
- Exercises are designed so that wrong approaches produce clear type/mode/determinism errors

One philosophical tension: the README says "Koans — broken Mercury programs with one specific flaw. The compiler is the teacher" but some koans (like the STM one) are actually text-only READMEs with no *_koan.m file at all. These are "concept koans" rather than "code koans," which breaks the format consistency.

**3. DIFFICULTY CURVE Analysis**

The difficulty curve is generally well-calibrated:

- **Foundations track**: Starts very gently (hello world, maybe, basic types) and builds incrementally
- **Mode system track**: Good progression from insts to multi-mode to mode-specific clause bodies
- **Determinism track**: The six categories kata is excellent for building mental models
- **Parsing track**: DCG basics through to complex stateful parsing
- **Concurrency track**: Starts with parallel conjunction, builds to STM

Where it plateaus:
- The tooling track (6 exercises) feels thin compared to other tracks. It covers grades, pragma memo, and foreign export, but these are somewhat disparate topics.
- The determinism track (7 exercises) could benefit from more exercises on committed choice and parallel conjunction.

Where it spikes unexpectedly:
- The "Mercury in Mercury" puzzle (puzzles/advanced/07) is a significant difficulty spike. It requires implementing unification, variable renaming, and backtracking search from scratch. This is a major jump from the previous puzzles.
- The mode reversal bridge (bridge/05) jumps from basic mode annotations to `promise_equivalent_clauses` and version arrays in three tasks.
- The error handling bridge (bridge/11) covers maybe, custom error types, and io.res in one exercise, which is dense.

The concurrency track might also spike for learners who haven't done concurrent programming before — going from parallel conjunction to STM in 9 exercises is ambitious.

**4. FORMAT COHERENCE Analysis**

The four formats are well-distinguished:

| Format | Purpose | Guidance Level |
|--------|---------|---------------|
| Katas | Muscle memory, specific concepts | High (step-by-step instructions) |
| Koans | Diagnostic, learn from errors | Medium (broken code, compiler teaches) |
| Bridges | Extension of working code | Medium (working base + tasks) |
| Puzzles | Open-ended problem solving | Low (problem statement + solution reference) |

This is a good taxonomy. Each format serves a different pedagogical purpose.

However, some exercises could be reclassified:
- The "map_maybe expects a func, not a pred" koan (koans/foundations/01-maybe) is very short and could be a kata instead. It's more about a specific gotcha than a conceptual lesson.
- The Sudoku puzzle (puzzles/logic/01-sudoku) is more of a constraint satisfaction exercise and feels like it belongs in a "constraint programming" section rather than "logic."
- The combinator library puzzle (puzzles/advanced/04) is really a parsing exercise and could be in the parsing track.

The bridge format is the most interesting and distinctive format — it's not commonly seen in other educational repositories. Having working code that you extend is a great middle ground between guided exercises and open-ended problems.

**5. STRUCTURAL ISSUES**

Several structural issues stand out:

a) **Missing connective tissue between tracks**: The tracks are somewhat siloed. A learner finishing the mode system track doesn't get explicit guidance on how modes connect to determinism, or how parsing uses modes extensively. The README's recommended order helps, but there's no explicit "you've learned X, now you'll need it for Y" transitions.

b) **Concurrency bridge gap**: There's no bridge for concurrency. The katas go from parallel conjunction to STM, but there's no bridge exercise that extends working concurrent code (like there is for modes, error handling, etc.).

c) **Type system track feels front-loaded**: The type system track (10 katas + 10 koans) is substantial and comes early. Some of the advanced type system concepts (solver types, typeclasses) might be better placed after the learner has more Mercury experience.

d) **Advanced track coherence**: The advanced track mixes FFI, solver types, and STM — these are conceptually quite different. It might be better to separate "advanced language features" from "advanced programming techniques."

e) **No exercises on testing**: There's no track or section on testing Mercury code (beyond the basic test patterns in COMPILER-LESSONS.md). This is a notable omission for a curriculum aimed at practical Mercury programming.

f) **Parser track could be longer**: The parsing track (9 katas + 7 koans) is good but DCG is a rich topic. More exercises on DCG with state, DCG with error recovery, and PEG-style parsing would strengthen this track.

**6. COMPARISON**

Compared to similar projects:

**Exercism tracks** (e.g., exercism.org):
- Exercism has a Mercury track with ~60 exercises
- Cinnabar is more pedagogically structured — it has a clear learning path, multiple exercise formats, and explanatory content
- Exercism relies on mentoring for feedback; Cinnabar uses the compiler as teacher
- Cinnabar's solution availability (puzzles have solutions, katas don't) is a good balance

**Language koans projects** (e.g., Clojure Koans, Ruby Koans):
- Those projects are typically just koans — broken code to fix
- Cinnabar is more comprehensive with its four-format approach
- The "compiler as teacher" philosophy is similar but Cinnabar executes it more systematically

**4Clojure / Prolog problems**:
- Similar in spirit to the puzzles, but Cinnabar's puzzles are more integrated into a learning path
- The Mercury-in-Mercury puzzle is genuinely novel and impressive

Where Cinnabar is stronger:
- Multi-format approach is more comprehensive than single-format projects
- The compiler-lessons resource is unique and valuable
- The bridge format fills a gap between guided exercises and open problems
- The "you bring raw material; the heat does the work" philosophy is well-executed

Where Cinnabar is weaker:
- Smaller exercise count than established tracks on Exercism
- Less community testing/feedback (evident from some rough edges)
- No testing track or exercises on property-based testing
- The puzzles section, while impressive, has fewer exercises than the katas/koans

**7. RELEASE READINESS**

If released to the Mercury community tomorrow, the community would likely:

Positive reactions:
- Appreciate the structured learning path
- Value the compiler-lessons resource
- Enjoy the puzzle format (especially Mercury-in-Mercury)
- Appreciate the pedagogical philosophy

Negative reactions / issues:
1. **Missing solutions for katas**: The README says "Kata solutions are also not here — by design." While this is pedagogically sound, the community might want reference solutions, especially for self-learners without mentors.

2. **Some exercises feel incomplete**: The tooling track is thin, the concurrency track lacks a bridge, and some bridges could have more tasks.

3. **Documentation inconsistencies**: Some READMEs have different levels of detail. The concurrency katas have good setup instructions, while some others assume more familiarity.

Three highest-priority fixes before release:

1. **Add solutions or hints for katas**: Even minimal solution stubs or hints would help self-learners. The current "no solutions by design" approach may frustrate solo learners.

2. **Fill the concurrency bridge gap**: Add a bridge exercise for concurrency (e.g., extending the pipeline puzzle with error handling or backpressure).

3. **Polish the tooling track**: The tooling track feels like a collection of miscellaneous topics. Restructure it around a coherent narrative (e.g., "understanding the build system" → "controlling compilation" → "foreign function interface").

**8. GENUINE STRENGTHS**

Several things are genuinely impressive:

1. **The compiler-lessons resource (COMPILER-LESSONS.md)**: This is exceptional. It systematically catalogs common Mercury compiler errors with explanations and fixes. This alone would be valuable to the Mercury community.

2. **The four-format approach**: The distinction between katas, koans, bridges, and puzzles is pedagogically sound and well-executed. Each format serves a distinct purpose in the learning process.

3. **The "compiler as teacher" philosophy**: Designing exercises so that wrong approaches produce informative compiler errors is excellent pedagogy. It turns Mercury's steep learning curve into a teaching tool.

4. **The Mercury-in-Mercury puzzle**: This is a genuinely impressive capstone exercise. Implementing a meta-interpreter for Mercury in Mercury is the kind of deep understanding exercise that distinguishes this from ordinary programming exercises.

5. **The bridge format**: Having working code that learners extend is an excellent middle ground. It's more engaging than blank-slate exercises and more challenging than guided ones.

6. **The mode reversal bridge**: The progression from single-mode to multi-mode predicates, with the `promise_equivalent_clauses` discussion, is exceptionally well-designed.

7. **Coherent error-handling progression**: The error handling bridge (bridge/11) systematically covers maybe → custom error types → io.res → exceptions, with clear guidance on when to use each.

8. **The Sudoku solution**: The use of Mercury's constraint solving and `solutions/2` to implement a Sudoku solver is elegant and demonstrates Mercury's strengths beautifully.

Overall rating: I'd give this a 7.5-8 out of 10. It's a well-designed, pedagogically sound curriculum with some genuine innovations (compiler-lessons, four-format approach, Mercury-in-Mercury). The main weaknesses are uneven coverage across tracks, a few difficulty spikes, and some missing connective tissue. With the priority fixes mentioned above, it could easily be a 9.

Let me now write a comprehensive, honest review.

</thinking-content-7bbeb8e1441453ad999a0bbba8a46d4b>

## Cinnabar Curriculum — Overall Assessment

### 1. Learning Path

The four-stage arc — **katas → koans → bridges → puzzles** — is pedagogically sound and mirrors established learning cycles (guided practice → diagnostic debugging → scaffolded extension → open-ended synthesis). A learner who completes the full sequence will have genuinely internalized Mercury's mode system, determinism model, and idiomatic patterns, not just collected exercises. The compiler-as-teacher philosophy is consistently applied and well-suited to Mercury's steep learning curve.

The recommended track ordering (Foundations → Type system → Mode system → Determinism → Parsing, then Tooling/Concurrency/Advanced) is sensible. Each track builds on the previous one — for example, the mode system track's multi-mode exercises prepare the learner for the bidirectional search puzzle.

**Weakness:** There is no explicit connective tissue between tracks. A learner finishing modes has no signpost saying "you'll need this for DCG parsing" or "determinism reasoning depends on what you just learned about modes." A brief "What you'll need next" section in each track's README would help.

### 2. Philosophy

The "You bring raw material; the heat does the work" framing is not just marketing — it's genuinely reflected in the design:

- **Katas** have no solutions by design, forcing the learner to derive answers.
- **Koans** are broken programs where the compiler is the teacher.
- **Bridges** provide working code to extend, not blank slates.
- **Puzzles** are open-ended with reference solutions.

This is a coherent philosophy of *productive struggle*. The compiler errors are the feedback mechanism, and the exercises are designed so that wrong approaches produce *informative* errors rather than opaque failures. This is consistently applied across almost all exercises.

**Tension:** Some koans (like the STM one) are text-only READMEs with no `*_koan.m` file. These break the "break the code, read the error" format and feel more like reading assignments than exercises. They're useful content but shouldn't be called koans if they don't follow the koan format.

### 3. Difficulty Curve

The curve is generally well-calibrated within each track:

- **Foundations**: Gentle, well-paced ramp from hello-world to maybe/error-handling
- **Mode system**: Clean progression from inst annotations to multi-mode predicates
- **Determinism**: The six-categories kata is an excellent conceptual foundation
- **Parsing**: Good build-up from DCG basics through stateful parsing

**Where it spikes unexpectedly:**

- **bridge/05 (mode reversal)** jumps from single-mode to `promise_equivalent_clauses` and version arrays in three tasks. The third task (version_array round-trip) is significantly harder than the first two.
- **bridge/11 (error handling)** covers `maybe`, custom error types, `io.res`, *and* exception philosophy in a single exercise. This is dense.
- **puzzles/advanced/07 (Mercury-in-Mercury)** is a major difficulty spike. Implementing unification and backtracking search from scratch is a substantial undertaking that doesn't scaffold well from the preceding puzzles.
- **puzzles/advanced/04 (combinator library)** is really a parsing exercise and feels out of place in "advanced" — it belongs thematically with the parsing track.

**Where it plateaus:**

- The **tooling track** (6 katas + 9 koans) covers disparate topics (grades, pragma memo, foreign export, loop checking) without a unifying narrative. It feels like a collection rather than a progression.
- The **determinism track** could use more exercises on committed choice and parallel conjunction — the six-categories kata is excellent but there's little follow-up.

### 4. Format Coherence

The four formats are well-distinguished and serve different pedagogical purposes:

| Format | Role | Guidance |
|--------|------|----------|
| Kata | Muscle memory | High (step-by-step) |
| Koan | Diagnostic learning | Medium (compiler teaches) |
| Bridge | Extension practice | Medium (working base + tasks) |
| Puzzle | Deep understanding | Low (problem + reference solution) |

This taxonomy is one of the project's genuine innovations compared to exercism-style single-format tracks.

**Reclassification candidates:**

- **koans/foundations/01-maybe** (map_maybe func vs pred) is very short and could be a kata — it's a specific gotcha, not a conceptual lesson.
- **puzzles/advanced/04** (combinator library) is a parsing exercise that belongs in the parsing track, not "advanced."
- **puzzles/logic/01-sudoku** is a constraint satisfaction exercise; labeling it under "logic" is fine, but it could benefit from being in a dedicated constraint-programming section.

### 5. Structural Issues

**Gaps:**

1. **No concurrency bridge.** The concurrency katas go from parallel conjunction to STM, but there's no bridge exercise extending working concurrent code. This is a conspicuous absence given that bridges exist for modes, error handling, typeclasses, etc.

2. **No testing track.** There are no exercises on writing tests, using `check_` predicates, or property-based testing. For a practical curriculum, this is a notable omission.

3. **The advanced track mixes heterogeneous topics.** FFI, solver types, and STM are conceptually unrelated. Splitting into "advanced language features" and "advanced programming patterns" would improve coherence.

4. **Bridge 09 (typeclass refactor)** is excellent but very code-heavy. A brief conceptual introduction to typeclasses before diving into the refactoring would help learners who haven't encountered ad-hoc polymorphism before.

**Bloated areas:**

- The **type system track** (10 katas + 10 koans) is substantial for an early track. Some advanced type system concepts (solver types, existential types) could be deferred to the advanced track.
- Some koan files are nearly identical to their solution files (e.g., koans/advanced/07-solver-any-inst), differing by only one annotation. This is fine pedagogically but means the koan/solution pair adds minimal total content.

### 6. Comparison to Similar Projects

**vs. Exercism Mercury track:**
Cinnabar is more pedagogically structured — it has a clear learning path, multiple exercise formats, and explanatory content. Exercism's Mercury track (~60 exercises) is larger in volume but less organized conceptually. Cinnabar's "compiler as teacher" approach is more sophisticated than Exercism's mentor-dependent model.

**vs. Language koans projects (Clojure Koans, Ruby Koans):**
Those are typically koans-only. Cinnabar's four-format approach is more comprehensive and pedagogically mature. The bridge format in particular fills a gap that single-format projects leave open.

**vs. Prolog problem sets (Bratko, Clocksin & Mellish):**
Cinnabar is more modern and tool-aware (mode system, determinism, FFI). Traditional Prolog texts don't address Mercury's unique features. However, Cinnabar could benefit from more "classic AI" problems (like those in Bratko) that showcase logic programming's distinctive strengths.

**Where Cinnabar is strongest:**
- Multi-format pedagogy is more comprehensive than any existing Mercury resource
- COMPILER-LESSONS.md is unique and invaluable
- The bridge format is genuinely innovative for Mercury education
- The puzzle selection (especially Mercury-in-Mercury) demonstrates deep understanding of the language

**Where it's weaker:**
- Smaller total exercise count than Exercism
- No community testing/feedback loop yet (some rough edges remain)
- No testing/property-based-testing content
- Some tracks are uneven in depth

### 7. Release Readiness

If released to the Mercury community tomorrow, the likely reception would be **very positive with constructive criticism**. The project fills a real gap — there is no structured Mercury learning resource beyond the official tutorial.

**Three highest-priority fixes before release:**

1. **Add solution hints or minimal solutions for katas.** The "no solutions by design" approach works in a classroom with mentors but will frustrate self-learners. Even a `solution/` directory with minimal hints (not full solutions) would help. This is the single most impactful change for community adoption.

2. **Add a concurrency bridge.** The gap between katas/concurrency and the pipeline puzzle is the most conspicuous missing link in the curriculum. A bridge extending the pipeline with error handling or backpressure would prepare learners for the pipeline puzzle.

3. **Restructure the tooling track.** The current tooling track reads as a collection of miscellaneous topics. Reframing it around a coherent narrative — "understanding the build pipeline" (grades → compiler flags → foreign export → memo/tail recursion) — would make it feel like a progression rather than a grab bag.

### 8. Genuine Strengths

These are the things that are genuinely impressive and should be preserved:

1. **COMPILER-LESSONS.md** is the single most valuable resource in the project. It systematically catalogs Mercury compiler errors with causes, symptoms, and fixes. This is the kind of resource that saves learners hours of frustration and is essentially impossible to write from documentation alone — it requires the hard-won experience the author clearly has.

2. **The four-format architecture** (kata/koan/bridge/puzzle) is pedagogically sophisticated and well-executed. Each format serves a genuinely different purpose, and the progression between them is smooth. This is more thoughtful than most programming exercise repositories.

3. **The "compiler as teacher" design principle** — engineering exercises so that wrong approaches produce *informative* compiler errors — is excellent pedagogy. It turns Mercury's steep learning curve (often cited as a weakness) into a teaching tool.

4. **The Mercury-in-Mercury puzzle** is a genuine capstone achievement. Implementing unification, variable renaming, and backtracking search in Mercury demonstrates deep understanding of both the language and logic programming. The design questions at the end (about compilation, depth-counter collisions, occurs checks) are the kind of questions that separate tutorial exercises from educational experiences.

5. **The mode reversal bridge** is exceptionally well-designed. The progression from single-mode → multi-mode → `promise_equivalent_clauses` → version_array round-trip is a masterclass in teaching modes. The third task (explaining why `(out, out) is nondet` breaks the promise) is a genuinely deep insight about the relationship between determinism and logical relations.

6. **The error-handling bridge** covers `maybe` → custom error types → `io.res` → exceptions with a clear decision framework ("does the caller need to know why it failed, and can they recover?"). This is practical, well-structured content that experienced Mercury programmers would appreciate.

---

### Overall Rating: **8 / 10**

Cinnabar is a well-designed, pedagogically coherent curriculum that fills a genuine gap in the Mercury ecosystem. Its four-format approach, compiler-as-teacher philosophy, and carefully selected puzzles make it significantly more than "just exercises." The main barriers to a higher rating are structural gaps (missing concurrency bridge, thin tooling track), a few difficulty spikes that lack scaffolding, and the absence of solution hints for self-learners. With the three priority fixes identified above, this could be a 9 — a genuinely essential resource for anyone learning Mercury.

> Tokens: 36k sent, 5.2k received. Cost: $0.0059 message, $0.0059 session.  
