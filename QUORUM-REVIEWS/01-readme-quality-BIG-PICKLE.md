# Review 01 — README Quality

**Reviewer:** BIG-PICKLE
**Date:** 2026-06-22

## Overall Assessment

The project's README corpus (309 files across 8 kata tracks, 12 bridges, 21 puzzles, 80 koans) is unusually thorough for a pre-alpha curriculum. Every exercise has a README; every track has an index README. The consistent presence of `Why Mercury`, concrete build commands, explicit checkpoint criteria, and cross-references to `docs/TEMPLATES.md` at the bottom of each exercise shows strong architectural intent.

That said, the quality is uneven across tracks, with notable gaps in stale cross-references, missing sections, and structural inconsistencies that will confuse learners.

---

## Strengths

### 1. "Why Mercury" sections are the project's crown jewel

Most exercise READMEs include an introductory "Why Mercury" paragraph that explains what makes the concept distinctive in Mercury vs. other languages. This is the single highest-value pedagogical move in the curriculum. The strongest examples:

- **Bridge 05 — mode reversal**: "in most languages, a string-to-int parser and an int-to-string formatter are separate functions. Mercury's mode system lets you write the logical relationship once and declare two directions." This frames the concept in terms learners already understand (parsing/formatting) and then shows the Mercury twist.

- **Bridge 02 — pipeline-extend**: "passing a function to map or foldl is routine everywhere. What Mercury adds is that a higher-order argument carries an *inst* — the modes and determinism of the closure — and the compiler checks that the closure you pass matches what the consumer declared."

- **Determinism 01 — six-categories**: "in most languages determinism is a runtime property — you find out how many answers a routine has by running it. In Mercury it is a compile-time contract."

- **Advanced 08 — mutable state**: "Two live aliases to a mutable heap is exactly the bug that makes mutable state hard to reason about in other languages, and here it is a mode error at compile time, not a runtime surprise."

The pattern is consistent: name the familiar pain point → show Mercury's type-level solution → let the compiler enforce it. This is pedagogically sound.

### 2. Concrete build commands in every exercise

Every README shows `mmc --make ...` and often `./binary`. This is rare in open-source Mercury materials (which tend to assume the reader already knows the toolchain). For a curriculum targeting programmers new to Mercury, this is essential.

### 3. Explicit checkpoint criteria

Many exercises end with a "Checkpoint" section that tells the learner what they should be able to state or do. Examples:
- "You can state the one-line rule: a function is a `det`, single-mode predicate whose result nests in expressions" (mode-system/09-func-vs-pred)
- "You can explain why `read_line_as_string`'s result is `ok`/`eof`/`error` and not just `maybe(string)`" (foundations/12-io-patterns)
- "All six predicates compile with the correct determinism annotation" (determinism/01-six-categories)

These serve as metacognitive checkpoints — they tell the learner *how to know they're done*.

### 4. Cross-reference hygiene (mostly)

Most exercises reference prerequisites by exact path (`katas/foundations/02-maybe`). This makes the dependency graph explicit and navigable. The bridge index table and kata track indices maintain the same cross-reference style.

---

## Weaknesses

### 1. Foundations track uses inline "Concept:" text instead of section headings

In foundations katas (05-map, 06-set, 07-exceptions, etc.), the Concept is presented as bold inline text:

```
**Concept:** `io.open_input`/`io.close_input`, ...
```

But in determinism, mode-system, parsing, and other tracks, this is rendered as a proper section heading:

```
## The six categories
```

This inconsistency matters because:
- Learners scanning a README can't find the concept description by heading.
- The determinism and advanced tracks demonstrate that proper section headings work fine for Mercury concepts.
- TEMPLATES.md suggests a template but doesn't specify how "Concept" should be rendered, so each track improvised differently.

**Fix:** Standardize on `## Concept` as a level-2 heading in every kata README that uses the inline pattern. Affected files: foundations 05-map, 06-set, 07-exceptions, 08-built-in-types, 09-mode-inference, 10-record-update, 11-stdlib-collections, 12-io-patterns. (Determinism track already uses proper headings and is the model to follow.)

### 2. Stale cross-references from directory renumbering (8 occurrences)

The project renumbered some directories but didn't update their internal README references:

- `katas/foundations/05-map/README.md` line ~6: says "This kata builds on `# 02` (maybe)" — should be `02-maybe/` or reference the actual directory name, not an inline `# 02` that changed meaning.
- `katas/foundations/06-set/README.md` line ~5: says "This kata builds on `# 03` (string)" — should be `03-string/`.

These are not just cosmetic — they break the learner's ability to navigate the track by following cross-references.

**Fix:** Audit all inline `# NN` references and replace with actual directory paths or at least correct numbers.

### 3. Bridge 10 (parallel-pipeline) is missing "Why Mercury"

Bridge 10 is the *only* bridge without a "Why Mercury" section. Its README jumps straight into "`pipeline.m` is a working three-stage pipeline." This is a significant gap because parallel pipelines in Mercury involve unique concepts (channels with `cc_multi`, sentinel patterns, semaphore-based backpressure) that are not obvious to someone who's only seen threads in mainstream languages.

**Fix:** Add a "Why Mercury" paragraph, e.g.:

> **Why Mercury:** channel-based parallelism in Mercury is type- and determinism-checked. A channel carries values of known type; `channel.get` is `cc_multi` because it blocks until a value is available — the compiler tracks this. The bounded-buffer pattern built from a channel and semaphore is explicit composition, not a hidden queue. And the sentinel pattern (`no` meaning "no more data") is enforced by `maybe(T)`'s type: you cannot accidentally confuse a sentinel with real data.

### 4. No time estimates on any exercise

Every README describes what to build but none estimates how long it takes. For a self-directed learner (the target audience — see START-HERE.md's "solo dive" path), knowing "this takes about 20 minutes" vs "this is a 2-hour deep dive" is critical for planning.

**Fix:** Add a line after "After:" in each README: `**Time:** ~30 min`. This can be approximate — the point is to set expectations, not to be exact.

### 5. Koan READMEs are spartan

Koans have READMEs, but they tend to be 1-2 paragraphs of description with no "Why Mercury," no concept section, no checkpoint criteria. Compare:

- `koans/types/00-free-variable/README.md` — describes the topic but doesn't explain why Mercury's free-variable semantics are distinctive
- `katas/foundations/02-maybe/README.md` — full structure with concept, Why Mercury, tasks, checkpoint

The koan READMEs could benefit from the same template structure. This is lower priority (koans are meant to be read in sequence, and the `COMPILER-LESSONS.md` provides context), but the discrepancy is noticeable.

### 6. `docs/TEMPLATES.md` is not followed uniformly

TEMPLATES.md exists and is linked from track index READMEs, but the READMEs themselves don't always follow it. The bridge template in TEMPLATES.md specifies sections in order: "Why Mercury" → "Build and Run" → "Extension Tasks" → "What You Are Practising." Most bridges follow this, but:

- Bridge 04 (determinism-ratchet) has "Why Mercury" first, then "Build and run it first" — correct.
- Bridge 07 (parser-hardening) follows the same order — correct.
- Bridge 11 (error-handling) has "Why Mercury" but then jumps straight into extension tasks without a "Build and run it first" line for `error_patterns.m` (though a build command appears in a code block).

Minor variance, but for a curriculum that prides itself on consistency, these should be tightened.

### 7. README-first learning model inconsistent

The reactivation track (foundations/00-reactivation) uses a *predict-then-verify* method: "read the README, write down what you expect, then open the source." This is explicitly contrasted with passive reading. Every other track uses a *read-then-code* model: README explains the concept, then tasks ask you to write code. Both are valid, but the reactivation track is the very first thing a new learner encounters (it's #00 and START-HERE.md points to it first), and its methodology is completely different from everything that follows.

This might be intentional (reactivation is a warm-up, not a learning track), but it's worth documenting the methodology shift in the track index or in START-HERE.md so the learner isn't confused.

---

## Summary

| Dimension | Score (1-10) |
|-----------|-------------|
| Consistent structure | 7 |
| "Why Mercury" quality | 9 |
| Cross-reference accuracy | 6 |
| Metacognitive scaffolding | 8 |
| Time estimates | 0 |
| `docs/TEMPLATES.md` adherence | 7 |

**Overall README quality score: 7/10**

The READMEs are the project's strongest asset, held back by stale cross-references (fixable in minutes), missing "Why Mercury" in Bridge 10 (fixable in minutes), and the foundations track's inconsistent heading style (fixable in an hour). The optional time estimates and koan README enhancements would push this to 9/10.
