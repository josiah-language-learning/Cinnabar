
# aider chat started at 2026-06-18 16:13:30

> /home/josiah/.local/bin/aider --no-git --chat-mode ask --model openrouter/inclusionai/ring-2.6-1t --map-tokens 4000 --yes --no-auto-commits --message-file /tmp/ring-r1-prompt.txt --chat-history-file /home/josiah/Development/personal/education/self/polyparadigm-project/cinnabar/RING-REVIEWS/01-readme-quality.md  
> Aider v0.86.2  
> Model: openrouter/inclusionai/ring-2.6-1t with ask edit format  
> Git repo: none  
> Repo-map: disabled  
> https://aider.chat/HISTORY.html#release-notes  
> Would you like to see what's new in this version? (Y)es/(N)o [Yes]: y  

#### You are reviewing the Cinnabar Mercury curriculum project in the current directory. Cinnabar is a post-tutorial exercise repository for Mercury programmers — katas, koans, bridges, and puzzles organized into tracks (Foundations, Type system, Mode system, Determinism, Parsing, Tooling, Concurrency, Advanced).  
####   
#### REVIEW FOCUS: README files and conceptual quality.  
####   
#### Read the root README.md, a representative sample of katas/*/README.md files, a few koans/*/README.md files, several bridge/*/README.md files, and several puzzles/*/README.md files.  
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



The user is asking me to review the Cinnabar Mercury curriculum project, but they explicitly stated in their first message: "I am not sharing the full contents of any files with you yet." This means I don't have any file contents to review. I need to point this out and ask them to share the relevant README files so I can perform the review.

</thinking-content-7bbeb8e1441453ad999a0bbba8a46d4b>

I appreciate the detailed review brief, but there's a blocker: you mentioned that you're not sharing the full contents of any files yet. To perform the evaluation you've described, I need to actually read the README files — the root `README.md`, and a representative sample from `katas/`, `koans/`, `bridges/`, and `puzzles/`.

Could you share the contents of the files you'd like me to review? Even a partial selection (e.g., the root README plus 2–3 from each track category) would be enough to start the analysis. Once I have the text in front of me, I can address all seven of your evaluation criteria with specific quotes and line references.

> Tokens: 343 sent, 271 received. Cost: $0.00020 message, $0.00020 session.  

# aider chat started at 2026-06-18 16:15:17

> /home/josiah/.local/bin/aider --no-git --chat-mode ask --model openrouter/inclusionai/ring-2.6-1t --map-tokens 1000 --yes --no-auto-commits --read README.md --read katas/README.md --read katas/foundations/README.md --read katas/determinism/README.md --read katas/mode-system/README.md --read katas/type-system/README.md --read katas/concurrency/README.md --read katas/advanced/README.md --read katas/determinism/01-six-categories/README.md --read katas/mode-system/04-higher-order-insts/README.md --read katas/type-system/04-type-classes/README.md --read katas/concurrency/01-parallel-conjunction/README.md --read koans/README.md --read koans/foundations/01-maybe/README.md --read koans/determinism/01-det-mismatch/README.md --read koans/mode-system/01-free-variable/README.md --read bridge/04-determinism-ratchet/README.md --read bridge/05-mode-reversal/README.md --read bridge/09-typeclass-refactor/README.md --read bridge/10-parallel-pipeline/README.md --read puzzles/advanced/03-bidirectional-search/README.md --read puzzles/advanced/04-combinator-library/README.md --read puzzles/advanced/07-mercury-in-mercury/README.md --read puzzles/concurrent/02-pipeline/README.md --read puzzles/logic/01-sudoku/README.md --message-file /tmp/ring-r1-prompt.txt --chat-history-file /home/josiah/Development/personal/education/self/polyparadigm-project/cinnabar/RING-REVIEWS/01-readme-quality.md  
> Error: Read-only file /home/josiah/Development/personal/education/self/polyparadigm-project/cinnabar/koans/mode-system/01-free-variable/README.md does not exist. Skipping.  
> Aider v0.86.2  
> Model: openrouter/inclusionai/ring-2.6-1t with ask edit format  
> Git repo: none  
> Repo-map: disabled  
> Added puzzles/advanced/07-mercury-in-mercury/README.md to the chat (read-only).  
> Added puzzles/logic/01-sudoku/README.md to the chat (read-only).  
> Added katas/determinism/README.md to the chat (read-only).  
> Added katas/mode-system/README.md to the chat (read-only).  
> Added puzzles/advanced/04-combinator-library/README.md to the chat (read-only).  
> Added puzzles/concurrent/02-pipeline/README.md to the chat (read-only).  
> Added bridge/10-parallel-pipeline/README.md to the chat (read-only).  
> Added bridge/04-determinism-ratchet/README.md to the chat (read-only).  
> Added katas/type-system/README.md to the chat (read-only).  
> Added katas/concurrency/01-parallel-conjunction/README.md to the chat (read-only).  
> Added katas/advanced/README.md to the chat (read-only).  
> Added koans/determinism/01-det-mismatch/README.md to the chat (read-only).  
> Added katas/concurrency/README.md to the chat (read-only).  
> Added katas/type-system/04-type-classes/README.md to the chat (read-only).  
> Added katas/determinism/01-six-categories/README.md to the chat (read-only).  
> Added koans/README.md to the chat (read-only).  
> Added bridge/09-typeclass-refactor/README.md to the chat (read-only).  
> Added bridge/05-mode-reversal/README.md to the chat (read-only).  
> Added README.md to the chat (read-only).  
> Added katas/README.md to the chat (read-only).  
> Added koans/foundations/01-maybe/README.md to the chat (read-only).  
> Added katas/mode-system/04-higher-order-insts/README.md to the chat (read-only).  
> Added puzzles/advanced/03-bidirectional-search/README.md to the chat (read-only).  
> Added katas/foundations/README.md to the chat (read-only).  

#### You are reviewing the Cinnabar Mercury curriculum project in the current directory. Cinnabar is a post-tutorial exercise repository for Mercury programmers — katas, koans, bridges, and puzzles organized into tracks (Foundations, Type system, Mode system, Determinism, Parsing, Tooling, Concurrency, Advanced).  
####   
#### REVIEW FOCUS: README files and conceptual quality.  
####   
#### Read the root README.md, a representative sample of katas/*/README.md files, a few koans/*/README.md files, several bridge/*/README.md files, and several puzzles/*/README.md files.  
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



The user is asking me to review the Cinnabar Mercury curriculum project's README files. They've provided several representative README files in the prompt context. Let me analyze them systematically across the seven evaluation criteria.

Let me work through what I have:

**Root README.md** — The main project overview
**Katas:** `katas/determinism/README.md`, `katas/mode-system/README.md`, `katas/type-system/README.md`, `katas/concurrency/README.md`, `katas/advanced/README.md`, `katas/README.md`, `katas/foundations/README.md`
**Koans:** `koans/determinism/01-det-mismatch/README.md`, `koans/foundations/01-maybe/README.md`, `koans/README.md`
**Bridges:** `bridge/04-determinism-ratchet/README.md`, `bridge/05-mode-reversal/README.md`, `bridge/09-typeclass-refactor/README.md`, `bridge/10-parallel-pipeline/README.md`
**Puzzles:** `puzzles/advanced/07-mercury-in-mercury/README.md`, `puzzles/logic/01-sudoku/README.md`, `puzzles/advanced/04-combinator-library/README.md`, `puzzles/concurrent/02-pipeline/README.md`

Let me evaluate each criterion:

### 1. Clarity and self-containment

Looking at the puzzle READMEs — they're quite detailed. The Sudoku one gives a clear problem statement, representation, approach, key predicates to write, and a sample puzzle. The Mercury meta-interpreter one is extremely detailed with type definitions, what to implement, and design questions.

However, I notice some issues:
- The Sudoku README says "Prerequisites: `katas/determinism/01-six-categories` — `nondet`, `solutions/2`, generate-and-test" and "katas/foundations/05-map — `set(T)` for constraint checking" — but these are relative paths. A learner would need to know the project structure.
- The Mercury meta-interpreter lists prerequisites as "All previous advanced puzzles" and specific katas, which is reasonable.
- The koans are very brief — the "det mismatch" koan is clear but minimal. The "map_maybe expects a func" koan is also clear.

Some READMEs reference files that aren't provided (like `katas/foundations/05-map`), so a learner might not know what `set(T)` is without reading that kata first. But that's by design — prerequisites.

### 2. "Why Mercury" framing

The puzzles have "Why Mercury" sections:
- Sudoku: "the declarative generate-and-test idiom maps directly onto Sudoku. The interesting design question is *when* to apply constraints"
- Mercury meta-interpreter: "writing an interpreter for a logical language forces you to implement the exact mechanisms — unification, environment-based substitution, backtracking search — that Mercury's own compiler compiles away. After writing this, Mercury's mode system and determinism annotations cease to be magic."
- Combinator library: "building a combinator library forces you to put determinism in the types, not just in your head. Each combinator's determinism is a function of its argument combinators' determinisms — and Mercury verifies this."
- Pipeline: "a multi-stage pipeline demonstrates that channel-based concurrency in Mercury composes cleanly"

These are generally good — they explain *why this is interesting in Mercury specifically*, not just what you're building. The Sudoku one is slightly weaker — it could explain why Mercury's `nondet` and `solutions/2` are particularly well-suited beyond just "declarative."

The bridges have "Why Mercury" implicitly but not always explicitly. The determinism ratchet bridge says "Build and run it first" but doesn't have an explicit "Why Mercury" section.

### 3. Task scoping

The puzzles are well-scoped:
- Sudoku: gives the approach, key predicates, sample puzzle — specific enough to start, open enough in implementation
- Mercury meta-interpreter: very detailed with exact type signatures and function signatures to implement
- Combinator library: gives exact signatures for base and derived combinators, then specific tasks ("digit parser", "number parser", etc.)

The katas are less well-scoped in their READMEs — they're more like reading lists than exercises. The determinism kata says "One predicate per category" but doesn't give as much scaffolding.

The bridges are interesting — they give you a working file and specific extension tasks. The determinism ratchet bridge has three concrete tasks plus a "what you are practising" section.

The koans are very tightly scoped — one specific flaw, fix it. This is appropriate for the format.

### 4. Prerequisite chains

The prerequisites seem reasonable:
- Foundations track builds from 00 through 09
- The advanced puzzles reference specific katas
- Bridges reference what they build on

However, I notice some potential issues:
- `puzzles/logic/01-sudoku` references `katas/foundations/05-map` but the foundations track goes up to 09-mode-inference. Is 05-map the right reference? Looking at the foundations README, 05-map covers `map(K, V)` — but the Sudoku README references `set(T)` which is in `katas/foundations/06-set`. Actually, looking again, the Sudoku README says "katas/foundations/05-map — set(T) for constraint checking" — but 05-map is about `map`, not `set`. The set kata is 06-set. This looks like a potential error or at least imprecision.

Wait, re-reading: "Prerequisites: katas/determinism/01-six-categories — nondet, solutions/2, generate-and-test; katas/foundations/05-map — set(T) for constraint checking" — this says the map kata covers `set(T)`, but looking at the foundations track, 05 is about `map` and 06 is about `set`. This seems like a mistake.

### 5. Writing voice consistency

The voice is generally consistent — direct, instructional, uses second person ("Your task", "You must", "Implement these"). The puzzle READMEs are more detailed and explanatory. The koans are brief and direct. The bridges are somewhere in between.

Some minor inconsistencies:
- Some sections use "---" dividers, others use "###" headers
- The puzzle READMEs have "---" sections while katas use "|" tables
- The root README is more marketing-oriented

Overall the voice is reasonably consistent.

### 6. Notable outliers

**Better than average:**
- The Mercury meta-interpreter puzzle README is exceptionally detailed and well-structured. The design questions at the end are excellent.
- The determinism bridge (04-determinism-ratchet) has great progressive tasks
- The pipeline puzzle README is clean and well-structured with clear code examples

**Worse than average:**
- The koans are very thin — some are just a paragraph and a code snippet. The "map_maybe" koan is essentially "read the error, fix it" with minimal guidance. This is appropriate for koans but might frustrate beginners.
- The Sudoku README's "Approach" section gives away too much of the implementation strategy — it practically writes the code for you with the `fill_first_empty` predicate. This reduces the problem-solving aspect.
- The katas README files are essentially tables of contents with no exercise content — they're more like indexes than learning materials.

### 7. What to fix before public release

1. **Sudoku prerequisite reference**: `katas/foundations/05-map` is listed but the description says `set(T)` — should reference `katas/foundations/06-set` instead, or clarify.

2. **Sudoku approach gives away too much**: The `fill_first_empty` code is essentially the solution skeleton. Consider providing less implementation detail and more conceptual guidance.

3. **Koan READMEs are too sparse**: Some lack context about *why* the broken concept matters. The "map_maybe expects a func" koan doesn't explain when you'd want a func vs pred.

4. **Missing "Why Mercury" in bridges**: Most bridges lack an explicit "Why Mercury" framing section, unlike the puzzles.

5. **Consistent formatting**: Some READMEs use `---` section dividers, others use `###` headers. Standardize.

6. **Root README could have a clearer getting-started path**: The "Recommended order" section is helpful but could be more prominent.

7. **Design questions are inconsistent**: Some puzzles/bridges have great design questions (Mercury meta-interpreter, determinism ratchet, bidirectional search), while others have none (Sudoku, pipeline).

8. **The combinator library puzzle** has a design question that's excellent ("Why can't Mercury allow a single combinator that is polymorphic over determinism?") but the prerequisite chain assumes `katas/mode-system/04-higher-order-insts` which is quite specific — verify this is reachable from the foundations track.

Let me now compose a comprehensive review.

Overall rating: I'd say 7/10. The content is strong, the pedagogical approach is sound, and the progression is well-thought-out. The main issues are consistency, a few factual errors in prerequisites, and some READMEs being either too prescriptive or too sparse.

</thinking-content-7bbeb8e1441453ad999a0bbba8a46d4b>

## Cinnabar README Quality Review

### 1. Clarity and Self-Containment

**Strongest:** The puzzle READMEs are excellent. The Mercury meta-interpreter puzzle (`puzzles/advanced/07-mercury-in-mercury/README.md`) provides complete type definitions, exact signatures to implement, and a clear specification of what each predicate should do. A learner can genuinely start without external help:

> ```mercury
> :- pred rename(term_t::in, string::in, term_t::out) is det.
> ```
> "This maps `v("X")` to `v("X_N")` and leaves atoms, integers, and functor names unchanged."

The Sudoku puzzle (`puzzles/logic/01-sudoku/README.md`) similarly gives the representation, the approach, key predicates to write, and a sample puzzle with expected output.

**Weakest:** The koan READMEs are extremely thin. The "map_maybe expects a func" koan (`koans/foundations/01-maybe/README.md`) is essentially "run this, read the error, fix it" with no explanation of *when* you'd choose a `func` over a `pred` or why the distinction matters conceptually. The koans are formatted as "broken concept → fix it" but lack the context that makes the fix meaningful.

The katas READMEs (`katas/determinism/README.md`, `katas/mode-system/README.md`, etc.) are essentially tables of contents with one-line descriptions per exercise. They provide no instructional content themselves — which is fine for an index, but a learner landing on `katas/determinism/README.md` has no idea what to do first or why.

### 2. "Why Mercury" Framing

**Where it works well:**

The puzzle READMEs consistently have explicit "Why Mercury" sections that are genuinely insightful:

- **Mercury meta-interpreter:** *"writing an interpreter for a logical language forces you to implement the exact mechanisms — unification, environment-based substitution, backtracking search — that Mercury's own compiler compiles away. After writing this, Mercury's mode system and determinism annotations cease to be magic."*

- **Combinator library:** *"building a combinator library forces you to put determinism in the types, not just in your head. Each combinator's determinism is a function of its argument combinators' determinisms — and Mercury verifies this."*

- **Sudoku:** *"the declarative generate-and-test idiom maps directly onto Sudoku. The interesting design question is *when* to apply constraints — early pruning dramatically reduces the search space."*

These explain what the exercise teaches about Mercury's specific mechanisms, not just what you build.

**Where it's missing:** Most bridge READMEs lack an explicit "Why Mercury" section. The determinism ratchet bridge (`bridge/04-determinism-ratchet/README.md`) jumps straight to "Build and run it first" without explaining *why* this exercise matters for understanding Mercury. The mode reversal bridge (`bridge/05-mode-reversal/README.md`) similarly lacks framing. The "What you are practising" sections at the end partially compensate, but the motivating framing at the top is absent.

The pipeline puzzle (`puzzles/concurrent/02-pipeline/README.md`) has a "Why Mercury" that's too generic: *"a multi-stage pipeline demonstrates that channel-based concurrency in Mercury composes cleanly."* This could apply to any language with channels. It should explain what's specifically Mercury-ish about the approach — the mode threading of `!IO`, the use of `maybe` sentinels instead of explicit close/join, etc.

### 3. Task Scoping

**Well-scoped:** The combinator library puzzle gives exact signatures for base combinators, then specific build targets:

> "Using only your combinators: 1. A `digit` parser (semidet)... 2. A `number` parser (det)... 3. A `literal(string)` parser (semidet)"

The determinism ratchet bridge has three progressive tasks that each build on the last, plus a parallel search task that requires understanding why `&` requires `det`.

The Mercury meta-interpreter is granular enough — each of the five components (rename, deref, unify, solve, apply_env) is a discrete, implementable unit.

**Poorly scoped:** The Sudoku puzzle's "Approach" section is arguably too prescriptive:

```mercury
fill_first_empty(Grid, Solved) :-
    ( first_empty(Grid, Row, Col) ->
        between(1, 9, Digit),
        place(Grid, Row, Col, Digit, Grid1),
        valid_placement(Grid1, Row, Col),
        fill_first_empty(Grid1, Solved)
    ;
        Solved = Grid
    ).
```

This is essentially the solution skeleton. A learner who reads this section has little design work left — the algorithmic structure is handed to them. The "Key predicates to write" list then becomes a mechanical decomposition exercise rather than a design challenge. Compare this to the meta-interpreter, which specifies *what* but not *how*, leaving the implementation strategy to the learner.

### 4. Prerequisite Chains

**Generally reasonable.** The recommended order in the root README is well-structured, and individual READMEs reference specific prerequisites. The progression from foundations → type system → mode system → determinism → parsing → advanced is pedagogically sound.

**Issue found:** The Sudoku puzzle lists:

> `katas/foundations/05-map` — `set(T)` for constraint checking

But looking at the foundations track, `05-map` covers `map(K, V)`, while `set(T)` is covered in `06-set`. This is a factual error — either the path should be `06-set` or the description should reference `map` operations. A learner following this prerequisite literally would study maps when they need sets.

**Another concern:** The combinator library puzzle requires `katas/mode-system/04-higher-order-insts`, which is the 4th mode-system kata. The prerequisite chain from foundations through mode system to this puzzle is long (foundations 01–09 → mode system 01–04 → puzzle). This is probably fine for the target audience but worth noting — a learner skipping any mode-system kata may struggle.

### 5. Writing Voice Consistency

The voice is mostly consistent — direct, instructional, uses second person, and favors code examples over prose. However:

- **Formatting inconsistency:** Puzzle READMEs use `---` horizontal rules as section dividers. Bridge READMEs use `###` headers. Katas use pipe-delimited tables. This gives the project a patchwork feel, as if different sections were written at different times or by different people.

- **Tone inconsistency:** The root README is more marketing-oriented (*"Ore for the Mercury programmer"*, *"The exercises are the heat"*). The puzzle READMEs are more technically precise. The koans are terse and clinical. These aren't necessarily bad, but the shift in register is noticeable when moving between sections.

- **Section structure inconsistency:** Puzzles reliably have "Prerequisites," "The problem," "What to implement," and "Design questions." Bridges have "After," "Extension tasks," and "What you are practising." Koans have "Broken concept," "Try it," and "Your task." Each format is internally consistent, but a learner moving between formats may feel disoriented.

### 6. Notable Outliers

**Best READMEs:**
- `puzzles/advanced/07-mercury-in-mercury/README.md` — Exceptionally well-structured. Clear type definitions, incremental build-up (five discrete components), excellent design questions that probe deep understanding (occurs check, depth-counter collision, compiler transformation). This is the gold standard of the curriculum.
- `bridge/04-determinism-ratchet/README.md` — Great progressive tasks from sequential to parallel search, with clear explanations of *why* `&` requires `det` and how `solutions/2` bridges the gap.
- `puzzles/advanced/04-combinator-library/README.md` — The design question about determinism-polymorphic combinators is genuinely thought-provoking and well-framed.

**Weakest READMEs:**
- `koans/foundations/01-maybe/README.md` — Too sparse. "Fix it" with no explanation of why the fix matters or what the underlying concept is.
- `koans/foundations/07-built-in-types/README.md` (referenced but not provided in full) — appears to exist only as a directory entry.
- `katas/README.md` — Literally just a one-paragraph intro and a table. No guidance on how to use the track.

### 7. Recommendations Before Public Release

1. **Fix the Sudoku prerequisite** — change `katas/foundations/05-map` to `katas/foundations/06-set`, or update the description to accurately reflect what the prerequisite covers.

2. **Reduce Sudoku hand-holding** — consider removing the `fill_first_empty` code skeleton from the "Approach" section and replacing it with a conceptual description of the strategy. Let the learner design the recursion pattern.

3. **Add "Why Mercury" to bridges** — each bridge should have a brief paragraph explaining what Mercury-specific concept or mechanism the exercise illuminates, not just what you build.

4. **Enrich koan READMEs** — add 1–2 sentences explaining *why* the broken concept matters and *what the learner should notice* when reading the compiler error. Koans should teach through the error, but the README needs to set up that learning moment.

5. **Standardize formatting** — pick one heading style (`###` or `---`), one table format, and one section ordering convention. Apply it across all READMEs.

6. **Add design questions to more exercises** — the design questions in the Mercury meta-interpreter, combinator library, and bidirectional search are some of the most valuable parts of the curriculum. The Sudoku, pipeline, and mode reversal exercises would benefit from similar reflective questions.

7. **Add a "What to observe" or "What to try" section to koans** — the determinism koan (`koans/determinism/01-det-mismatch/README.md`) says "Fix by adding an else branch" but doesn't suggest experimenting with the compiler output. A prompt like "Try removing the else branch and read the error message carefully" would deepen learning.

8. **Clarify the bridge workflow** — bridge READMEs assume you've "built and run it first." Consider adding a brief one-liner on expected output so learners know they've set up correctly before starting extension tasks.

---

**Overall Rating: 7/10**

The curriculum has strong pedagogical bones — the topic progression is sound, the puzzle concepts are well-chosen to teach specific Mercury mechanisms, and the best READMEs (meta-interpreter, combinator library, determinism ratchet) are genuinely excellent. The main issues are consistency (formatting, voice, depth), a factual prerequisite error, and a few READMEs that are either too prescriptive (Sudoku) or too sparse (koans) to maximize learning. With the fixes above — most of which are editorial rather than structural — this would be a 9.

> Tokens: 15k sent, 4.4k received. Cost: $0.0039 message, $0.0039 session.  
