
# aider chat started at 2026-06-19 19:13:19

> /home/josiah/.local/bin/aider --no-git --chat-mode ask --model openrouter/inclusionai/ring-2.6-1t --map-tokens 1000 --yes --no-auto-commits --read README.md --read katas/README.md --read katas/foundations/README.md --read katas/determinism/README.md --read katas/concurrency/README.md --read katas/advanced/README.md --read katas/determinism/07-promise-equiv-solutions/README.md --read katas/advanced/02-solver-types/README.md --read katas/concurrency/09-stm/README.md --read koans/README.md --read koans/foundations/20-int-comparison-import/README.md --read koans/advanced/07-solver-any-inst/README.md --read bridge/04-determinism-ratchet/README.md --read bridge/05-mode-reversal/README.md --read bridge/11-error-handling/README.md --read puzzles/advanced/07-mercury-in-mercury/README.md --read puzzles/advanced/04-combinator-library/README.md --read puzzles/logic/01-sudoku/README.md --read puzzles/concurrent/02-pipeline/README.md --message-file /tmp/ring-r1-prompt.txt --chat-history-file /home/josiah/Development/personal/education/self/polyparadigm-project/cinnabar/RING-REVIEWS/01-readme-quality.md  
> Aider v0.86.2  
> Model: openrouter/inclusionai/ring-2.6-1t with ask edit format  
> Git repo: none  
> Repo-map: disabled  
> Added katas/concurrency/09-stm/README.md to the chat (read-only).  
> Added koans/foundations/20-int-comparison-import/README.md to the chat (read-only).  
> Added puzzles/advanced/04-combinator-library/README.md to the chat (read-only).  
> Added katas/determinism/README.md to the chat (read-only).  
> Added README.md to the chat (read-only).  
> Added puzzles/advanced/07-mercury-in-mercury/README.md to the chat (read-only).  
> Added puzzles/concurrent/02-pipeline/README.md to the chat (read-only).  
> Added bridge/05-mode-reversal/README.md to the chat (read-only).  
> Added katas/advanced/README.md to the chat (read-only).  
> Added bridge/04-determinism-ratchet/README.md to the chat (read-only).  
> Added koans/advanced/07-solver-any-inst/README.md to the chat (read-only).  
> Added bridge/11-error-handling/README.md to the chat (read-only).  
> Added katas/concurrency/README.md to the chat (read-only).  
> Added puzzles/logic/01-sudoku/README.md to the chat (read-only).  
> Added koans/README.md to the chat (read-only).  
> Added katas/determinism/07-promise-equiv-solutions/README.md to the chat (read-only).  
> Added katas/foundations/README.md to the chat (read-only).  
> Added katas/advanced/02-solver-types/README.md to the chat (read-only).  
> Added katas/README.md to the chat (read-only).  
> https://aider.chat/HISTORY.html#release-notes  
> Would you like to see what's new in this version? (Y)es/(N)o [Yes]: y  

#### You are reviewing the Cinnabar Mercury curriculum project in the current directory. Cinnabar is a post-tutorial exercise repository for Mercury programmers — katas, koans, bridges, and puzzles organized into tracks (Foundations, Type system, Mode system, Determinism, Parsing, Tooling, Concurrency, Advanced).  
####   
#### REVIEW FOCUS: README files and conceptual quality.  
####   
#### You have been given a representative sample of README files from across the curriculum.  
####   
#### Evaluate:  
#### 1. Are exercise descriptions clear and self-contained? Can a learner start without external help?  
#### 2. Does the "why Mercury" framing in puzzle and bridge READMEs explain what the exercise specifically teaches about Mercury — not just what it builds?  
#### 3. Are tasks well-scoped — specific enough to start, open enough to require thinking?  
#### 4. Are prerequisite chains reasonable and consistent?  
#### 5. Is the writing voice consistent across the curriculum?  
#### 6. Are there README files that are notably better or worse than the average?  
#### 7. What would you tell the author to fix before releasing this publicly?  
####   
#### Be specific: quote lines or sections that illustrate your points. Rate the overall README quality on a 1–10 scale with a brief justification.  

<thinking-content-7bbeb8e1441453ad999a0bbba8a46d4b>



The user is asking me to evaluate the README files from the Cinnabar Mercury curriculum project based on a representative sample they've provided. Let me carefully analyze each of the seven evaluation criteria using the specific README files shared.

Let me go through the files provided:

1. `katas/concurrency/09-stm/README.md` — Kata: Software Transactional Memory
2. `koans/foundations/20-int-comparison-import/README.md` — Koan: integer comparison operators
3. `puzzles/advanced/04-combinator-library/README.md` — Puzzle: parser combinator library
4. `katas/determinism/README.md` — Determinism track overview
5. `README.md` — Project-level README (Cinnabar)
6. `puzzles/advanced/07-mercury-in-mercury/README.md` — Puzzle: Mercury meta-interpreter
7. `puzzles/concurrent/02-pipeline/README.md` — Puzzle: three-stage pipeline
8. `bridge/05-mode-reversal/README.md` — Bridge: mode reversal
9. `katas/advanced/README.md` — Advanced track overview
10. `bridge/04-determinism-ratchet/README.md` — Bridge: determinism ratchet
11. `koans/advanced/07-solver-any-inst/README.md` — Koan: solver type variables
12. `bridge/11-error-handling/README.md` — Bridge: error-handling patterns
13. `katas/concurrency/README.md` — Concurrency track overview
14. `puzzles/logic/01-sudoku/README.md` — Puzzle: Sudoku
15. `koans/README.md` — Koans overview
16. `katas/determinism/07-promise-equiv-solutions/README.md` — Kata: promise_equivalent_solutions
17. `katas/foundations/README.md` — Foundations track overview
18. `katas/advanced/02-solver-types/README.md` — Kata: solver types
19. `katas/README.md` — Katas overview

Now let me evaluate each criterion:

**1. Are exercise descriptions clear and self-contained?**

The STM kata is excellent — it provides the full API reference, a scenario, step-by-step tasks, and expected output. A learner can start without external help.

The koans are brief but effective — they tell you what's broken and what to fix. The int-comparison koan is clear: "add `import_module int`."

The parser combinator puzzle is very detailed with exact type signatures and determinism annotations. However, it might be overwhelming — it defines a lot of types and combinators upfront.

The meta-interpreter puzzle has a great checkpoint structure (A, B, C) that lets learners verify incrementally.

The pipeline puzzle provides complete structure code but also shows the stage implementations — this is borderline. It's very helpful but might be too complete for a "puzzle."

The bridges like mode-reversal and determinism-ratchet say "Build X" but then provide substantial structure code. The mode-reversal bridge says "Build and run it first" but doesn't show the actual code of `convert.m` — it only shows the predicate declaration. This creates a gap: the learner needs to find the file.

**2. Does the "why Mercury" framing explain what the exercise specifically teaches?**

The STM kata: "The key insight: `withdraw` and `deposit` each have `stm::di, stm::uo` arguments. Chaining them threads the stm log through both operations." — This is good, it explains the Mercury-specific mechanism.

The pipeline puzzle: "Why Mercury: the pipeline makes three Mercury-specific mechanics work together. `!IO` is a unique token..." — Excellent, directly ties to Mercury concepts.

The mode-reversal bridge: "Why Mercury: in most languages, a string-to-int parser and an int-to-string formatter are separate functions. Mercury's mode system lets you write the logical relationship once..." — Great, explains the Mercury-specific value.

The determinism ratchet bridge: "Why Mercury: determinism is a type-level constraint, not a convention. The `&` operator won't compile unless both conjuncts are `det`..." — Excellent.

The parser combinator puzzle: "Why Mercury: building a combinator library forces you to put determinism in the types, not just in your head." — Good but somewhat abstract.

The error-handling bridge: "Why Mercury: the type system makes the error contract part of the signature." — Good.

Overall, the "Why Mercury" framing is one of the strongest aspects of the curriculum.

**3. Are tasks well-scoped?**

The STM kata has 5 steps that build incrementally — well-scoped.

The meta-interpreter has checkpoints A, B, C — good incremental structure.

The determinism ratchet has 3 extension tasks that build on each other.

The parser combinator puzzle lists specific combinators to implement and specific things to build — well-scoped but ambitious.

The mode-reversal bridge has 3 tasks that escalate nicely.

The error-handling bridge has 3 tasks covering different error mechanisms.

Some koans are perhaps too narrow — the int-comparison koan is literally "add one import." That's fine for a koan, but it's extremely narrow.

**4. Are prerequisite chains reasonable and consistent?**

The STM kata lists no prerequisites in its README but is in the Concurrency track which lists `02-threads` as a prerequisite for `09-stm`. The track-level prerequisite chain is there but not in the individual kata.

The parser combinator puzzle lists: "katas/foundations/04-higher-order", "katas/determinism/01-six-categories", "katas/mode-system/04-higher-order-insts" — specific and reasonable.

The meta-interpreter lists: "All previous advanced puzzles", "katas/determinism/01-six-categories", "katas/mode-system/04-higher-order-insts" — reasonable but "all previous advanced puzzles" is vague.

The determinism ratchet says "After: katas/determinism/02-committed-choice" — clear.

The mode-reversal bridge says "After: katas/mode-system/02-multi-mode" — clear.

The error-handling bridge says "After: katas/foundations/02-maybe, katas/foundations/07-io-error-handling" — clear.

Overall, prerequisite chains are mostly consistent but could be more uniformly formatted. Some use "After:" and some use "Prerequisites:" and some use "Requires:".

**5. Is the writing voice consistent?**

The voice is generally informal, direct, and encouraging. It uses second person ("you"). The tone is conversational but technical.

However, there are inconsistencies:
- Some READMEs use "---" dividers, others use "##" headers
- The track overview READMEs (foundations, determinism, concurrency, advanced) are simple tables with brief descriptions
- The puzzle READMEs are more elaborate with "Why Mercury" sections, "Prerequisites", detailed descriptions
- The bridge READMEs have a different structure again
- The koan READMEs are very terse

The voice itself is consistent (conversational, direct), but the structure varies across exercise types.

**6. Notably better or worse READMEs?**

Better:
- STM kata: comprehensive, step-by-step, includes expected output
- Meta-interpreter: checkpoint structure is excellent for a complex puzzle
- Determinism ratchet: clear progression, good design questions
- Pipeline puzzle: clear structure, good "What to observe" section

Worse:
- Int-comparison koan: extremely terse, almost no explanation of the concept beyond "add this import"
- The koans overview README is just a table — no explanation of the koan format
- The katas overview README is just one paragraph and a table — very thin
- The determinism track overview is just a table — could use more context about the progression

**7. What to fix before public release?**

Several things:
1. The project-level README mentions "Bridges sit between katas and puzzles" and gives a recommended order, but the bridge READMEs themselves don't clearly explain how they bridge the gap. Some bridge READMEs could be more explicit about what prior knowledge they assume and what they're building toward.

2. The prerequisite notation is inconsistent — "Prerequisites:", "After:", "Requires:" are used interchangeably.

3. Some track overviews (foundations, determinism, concurrency, advanced) are just tables — they could benefit from brief narrative descriptions of the track's arc.

4. The mode-reversal bridge says "Build and run it first" but doesn't include the working code or point to a specific file to examine. It mentions `convert.m` but doesn't show what it contains.

5. The koans are very terse — some might benefit from slightly more explanation of the concept being taught, even if the fix is simple.

6. The parser combinator puzzle's "Design question" about determinism-polymorphic combinators is excellent but might be better placed as a stretch goal rather than a core task.

7. The meta-interpreter's "Design questions" at the end are excellent but somewhat abstract — they're more theoretical than the practical checkpoints.

8. Missing: some READMEs don't include expected output, which is very helpful for self-directed learners.

9. The "Recommended order" section in the main README is great but could be more visually structured.

Let me now formulate my overall assessment and rating.

Overall, the README quality is quite good — this is clearly written by someone who understands both Mercury and pedagogy. The "Why Mercury" framing is excellent and distinctive. The step-by-step structures in the katas and checkpoints in the puzzles are well-designed. The main areas for improvement are consistency in formatting, completeness of prerequisite chains, and ensuring every exercise has enough context for a self-directed learner to start without external help.

I'd rate this around 7.5-8 out of 10. Let me settle on 8 with specific caveats.


</thinking-content-7bbeb8e1441453ad999a0bbba8a46d4b>

## Cinnabar README Quality Review

### 1. Clarity and Self-Containment

**Strongest examples:**

The STM kata (`katas/concurrency/09-stm/README.md`) is the gold standard in this sample. It provides the full API surface inline, a concrete scenario, five incremental steps, and expected output:

> ```
> savings:  700
> checking: 500
> ```

A learner can open this file and start working without touching any other document.

The meta-interpreter puzzle (`puzzles/advanced/07-mercury-in-mercury/README.md`) uses a **checkpoint structure** (Checkpoint A, B, C) that lets learners verify correctness at each stage before advancing. This is excellent for a complex, multi-component exercise.

**Weaknesses:**

The mode-reversal bridge (`bridge/05-mode-reversal/README.md`) says *"Build and run it first"* but never shows the contents of `convert.m`. It describes the predicate signature but gives the learner no way to see the starting point without opening a separate file. Compare this to the pipeline puzzle, which provides complete stage implementations inline.

Several track-level overviews are **too thin** to orient a learner. `katas/foundations/README.md` is one paragraph and a table. `katas/determinism/README.md` is just a table with one-line descriptions. A learner hitting these cold has no sense of the arc or why the ordering matters.

The int-comparison koan (`koans/foundations/20-int-comparison-import/README.md`) is functional but extremely terse — it tells you what's broken and what to add, but provides almost zero conceptual framing for *why* this matters:

> Fix: add `import_module int` to the implementation section.

This is fine as a quick exercise, but it doesn't help a learner build a mental model of Mercury's module system.

---

### 2. "Why Mercury" Framing

This is one of the curriculum's strongest assets. Several READMEs excel at tying the exercise to a specific Mercury mechanism rather than a generic programming task:

**Pipeline puzzle** (`puzzles/concurrent/02-pipeline/README.md`):
> *"Why Mercury: the pipeline makes three Mercury-specific mechanics work together. `!IO` is a unique token that cannot be shared across threads..."*

**Determinism ratchet bridge** (`bridge/04-determinism-ratchet/README.md`):
> *"Why Mercury: determinism is a type-level constraint, not a convention. The `&` operator won't compile unless both conjuncts are `det`..."*

**Mode-reversal bridge** (`bridge/05-mode-reversal/README.md`):
> *"Why Mercury: in most languages, a string-to-int parser and an int-to-string formatter are separate functions. Mercury's mode system lets you write the logical relationship once..."*

These are genuinely explanatory — they don't just say "this is a Mercury exercise," they identify the *specific language mechanism* the exercise is designed to teach.

**Weaker example:** The parser combinator puzzle says:
> *"Why Mercury: building a combinator library forces you to put determinism in the types, not just in your head."*

This is true but abstract. It could be strengthened by noting that Mercury's mode system will *reject* a combinator that tries to be polymorphic over determinism — a concrete, surprising constraint the learner will hit.

---

### 3. Task Scoping

Most exercises hit a good balance between specificity and openness:

- **STM kata:** Five concrete steps that build on each other. Step 3 (transfer) says "call `withdraw` then `deposit`" — specific enough to start, but the learner must figure out how the `stm` log threading works.
- **Determinism ratchet:** Three extension tasks that escalate from "return first solution" to "parallel search" to "parameterized early exit." Each is a meaningful increment.
- **Mode-reversal bridge:** Three tasks that progress from "add a reverse mode" to "attempt a third mode" to "build something with both modes."
- **Meta-interpreter:** Checkpoints A/B/C provide a natural scaffolding.

**Potential issue:** The parser combinator puzzle defines six base/derived combinators with exact mode signatures. This is very detailed, which is good for precision, but the wall of type declarations might be intimidating before the learner has written a single line. A brief "here's what you'll build" narrative before the API spec would help.

---

### 4. Prerequisite Chains

Most exercises have clear, reasonable prerequisites:

| Exercise | Prerequisite format | Quality |
|---|---|---|
| Parser combinator | `Prerequisites:` — specific katas listed | ✅ Clear |
| Determinism ratchet | `After:` — single kata | ✅ Clear |
| Mode-reversal bridge | `After:` — single kata | ✅ Clear |
| Error-handling bridge | `After:` — two specific katas | ✅ Clear |
| Meta-interpreter | "All previous advanced puzzles" | ⚠️ Vague |
| STM kata | None listed in README | ⚠️ Missing |

**Inconsistency:** Three different keywords are used: `Prerequisites:`, `After:`, and `Requires:` (in the pipeline puzzle). These should be standardized.

The meta-interpreter's "All previous advanced puzzles" is too vague — a learner doesn't know which specific skills from which puzzles are needed. The STM kata lists no prerequisites at all in its README, even though the concurrency track README lists `02-threads` as a prerequisite for `09-stm`.

---

### 5. Writing Voice Consistency

The voice is **mostly consistent**: informal, direct, second-person ("you"), technically precise but not dry. The tone feels like a knowledgeable colleague walking you through something.

**Structural inconsistencies:**

- Track overviews (foundations, determinism, concurrency, advanced) use only tables — no narrative
- Kata READMEs use `---` horizontal rules and `##` headers
- Bridge READMEs use `---` dividers and a different header structure
- Puzzle READMEs have `##` headers with `---` dividers
- The project-level README uses `---` dividers and `###` headers

The voice is consistent; the **information architecture** is not. A learner moving between exercise types will encounter different structures.

---

### 6. Notable Highs and Lows

**Best READMEs:**
- `katas/concurrency/09-stm` — comprehensive, incremental, includes expected output
- `puzzles/advanced/07-mercury-in-mercury` — checkpoint structure is ideal for a complex project
- `bridge/04-determinism-ratchet` — clear progression, excellent design questions
- `puzzles/concurrent/02-pipeline` — clean structure, great "What to observe" section

**Weakest READMEs:**
- `koans/foundations/20-int-comparison-import` — too terse, minimal conceptual framing
- `katas/README.md` — one paragraph, no explanation of the kata format or how to use them
- `koans/README.md` — just a table, no explanation of the koan workflow (broken code → fix → learn)
- `katas/foundations/README.md` — table only, no narrative arc

---

### 7. Recommendations Before Public Release

**Critical fixes:**

1. **Standardize prerequisite notation.** Pick one keyword (`Prerequisites:` or `After:`) and use it everywhere. The current mix of `Prerequisites:`, `After:`, and `Requires:` is confusing.

2. **Add prerequisites to the STM kata README.** It currently lists none, but requires `thread.spawn` and `channel` knowledge from earlier concurrency katas.

3. **Make the mode-reversal bridge self-contained.** Either include the `convert.m` starting code inline or add a clear pointer: "Open `convert.m` — you will see a working program with a single predicate..."

4. **Expand track-level overviews.** The `foundations/`, `determinism/`, `concurrency/`, and `advanced/` READMEs are just tables. Add 2-3 sentences explaining the arc: what the track teaches, why the order matters, and what the learner should be able to do after completing it.

5. **Add expected output to more exercises.** The STM kata and Sudoku puzzle include it, but most others don't. Expected output is critical for self-directed learners to know if they've succeeded.

6. **Clarify the koan workflow.** The koans README should explicitly describe the workflow: "Each koan is a broken program. Compile it, read the error, form a hypothesis, then check `solution/`." The current README assumes the reader already knows.

7. **Tighten the meta-interpreter's design questions.** The three questions at the end are excellent but highly theoretical. Consider marking them as "Stretch" or "For discussion" so they don't feel like required homework after a complex implementation.

8. **Add a "What you are practising" section to katas.** The bridges and puzzles have this; the katas don't. A one-line summary of the core skill being drilled would help learners self-assess.

---

### Overall Rating: **8 / 10**

The README quality is genuinely good — clearly written by someone who understands both Mercury and CS pedagogy. The "Why Mercury" framing is a standout feature that distinguishes this from generic exercise repos. The main gaps are structural consistency (prerequisite notation, track overviews, expected output coverage) rather than conceptual problems. With the fixes above, this would be a 9.

> Tokens: 15k sent, 4.2k received. Cost: $0.0038 message, $0.0038 session.  
