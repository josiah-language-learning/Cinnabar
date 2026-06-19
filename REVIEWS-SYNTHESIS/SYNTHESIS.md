# Cinnabar review synthesis

*Synthesized 2026-06-19 by Claude Opus 4.8 from three independent review passes:*

- **Opus** (`OPUS-REVIEWS/`, 6 reviews) — Claude Opus 4.8, direct read of the current tree.
- **Codex** (`CODEX-REVIEWS/`, 6 reviews) — line-cited, harshest grader.
- **Ring** (`RING-REVIEWS/`, 5 reviews) — `inclusionai/ring-2.6-1t` via aider; most lenient.

Ring did not produce a separate "idiomatic Mercury" review; it folded that into its
code-quality and overall passes. Where the three disagree on a *technical* claim, I have
re-derived the answer from Mercury semantics and the actual source, and the adjudication is
in §3. **This synthesis supersedes any single review where they conflict.**

---

## Scorecard

| Dimension | Opus | Codex | Ring | Consensus |
|---|---|---|---|---|
| README quality | 6.5 | 6 | 8 | ~6.5 — strong prose, stale navigation |
| Coverage — breadth | 8 | 8 | 7.5 | **8** |
| Coverage — depth | 7.5 | 8 | 7.5 | ~7.5 |
| Correctness | 7 | 6 | 7.5 | ~7 |
| Code quality | 7 | 7 | 8 | ~7 |
| Idiomatic Mercury | 7 | 7 | (n/a) | 7 |
| Overall | 7 | 7 | 8 | **7** |

**Calibration note.** Read the spread, not just the numbers. Ring is consistently the
most generous and the least likely to catch a defect (it marked the entire bridge-11
solution and sudoku's `solutions/2` usage as correct — both have real issues). Codex is the
harshest and the most thorough on navigation/contracts, but it produced the one outright
*incorrect* technical claim in the whole set (§3.1). Opus sits in the middle and caught the
contract bugs Ring missed while rejecting the Codex error. **Treat consensus among all
three as high-confidence; treat a lone Ring "looks correct" as weak evidence.**

---

## 1. Consensus findings (all reviewers, or uncontested) — fix first

These appear in every relevant review or are uncontested and verified. Highest confidence.

1. **Stale navigation / index drift (release blocker).** Track and category index READMEs
   under-report the curriculum. Verified still-live: `katas/README.md` ("More tracks will
   follow", 8 exist); type-system lists 5 of 10; parsing 3 of 9; mode-system omits 06–07;
   determinism omits 04–06; foundations omits 10–11; `bridge/README.md` lists 4 of 11;
   `puzzles/README.md` under-lists concurrent and advanced. (Root table, advanced,
   concurrency, tooling indexes *are* current.) — *Opus, Codex, Ring.*

2. **`COMPILER-LESSONS.md` is the project's signature asset — preserve and feature it.**
   Singled out by Codex and Ring as the most valuable file; Opus concurs. Keep it linked
   from the root README (it is). — *all three.*

3. **The four-format arc + Mercury specificity is the core strength.** Kata → koan →
   bridge → puzzle is pedagogically sound; modes/determinism/insts/committed-choice as
   first-class topics is what distinguishes this from a generic exercise repo. Do not dilute
   it during cleanup. — *all three.*

4. **`FIX:` comments in reference solutions narrate edit history, not invariants.**
   `calculator.m:18,28,40,…` (also `pipeline.m`). Rewrite as durable design reasons. — *Opus,
   Codex, Ring (Ring called it "the single most problematic element").*

5. **Track-level overviews are too thin.** foundations/determinism/concurrency/advanced
   index READMEs are bare tables; add 2–3 sentences of arc per track. — *Opus, Codex, Ring.*

6. **Solver types are the largest coverage gap (but honestly documented).** Now a real
   declaration/mode exercise + koan, but still no runnable constraint store. A small
   finite-domain engine would convert the one "about a feature" topic into hands-on
   practice. — *all three; tracked in `CLP-PLAN.md`.*

---

## 2. Majority findings (2 of 3) — fix, medium-high confidence

7. **Bridge 11 silently swallows read errors.** `read_lines` maps `error(_)` → `[]`, then
   `load_users` returns `ok(...)`, contradicting the solution's own decision table that
   chose `io.res` to carry the error. — *Opus + Codex caught it; **Ring marked the bridge-11
   solution entirely correct** (a Ring miss). Verified real.*

8. **Bridge 10 fan-in can lose work.** `dispatch` sends `no` to both workers; each forwards
   `no` to the shared output; the unchanged writer stops at the first sentinel. "Total is
   still correct" is not guaranteed. Task 4 supervisor is a stub ("would restart here"). —
   *Opus + Codex; Ring did not review bridge 10 for correctness. Verified real.*

9. **Existential-construction contradiction.** `plugins/solution/README.md` claims
   existential packing "is not available from regular clause heads," but
   `koans/advanced/02-existential-escape` teaches the `'new tagged'(...)` syntax that does
   exactly that. The plugins example failed only because it used ordinary `plugin(upper)`.
   — *Opus + Codex; Ring silent. Verified real.*

10. **`nondet_koan.m` has two flaws.** `all_factors` passes a `list(int)` where
    `find_factor` expects an `int` — a type error that fires *before* the intended
    determinism error, breaking the koan's "one diagnostic" rule. — *Opus + Codex; Ring
    reviewed `01-det-mismatch` instead. Verified real.*

11. **Parsers manufacture `det` by swallowing invalid input.** `calculator.m` (`"1 @ 2"` →
    `yes(1)`), `csv_reader.m` (failed row = EOF, remainder ignored), `config_parser.m`
    (malformed lines dropped). Make the failure contract visible in the type/determinism, or
    name+document the lenient behavior. — *Opus + Codex (this is Codex's and Opus's top
    code/idiom item); Ring did not flag it.*

12. **`sudoku.m` collects all solutions to use the first.** `solutions(solve(P), [S|_])` —
    use committed choice for first-solution search (contrast `nqueens.m`, which legitimately
    needs the full list). — *Opus + Codex; **Ring marked it "correct."***

13. **`many`/`many_p` lack a progress invariant.** A semidet parser that succeeds without
    consuming input loops forever. Document/enforce "must consume on success." — *Opus +
    Codex; Ring marked combinators fine.*

14. **`memoized_search.m` magic `999999` seed + genuinely unused `maybe` import.** Seed from
    the first solution or fold to `maybe(pair(...))`. — *Opus + Codex + Ring (unused import).*

15. **`stats_pipeline.m`: non-minimal `cc_multi` main + "unique state" overstatement.** Use
    the `det` main + `promise_equivalent_solutions [!:IO]` pattern from `pipeline.m`; the
    count/sum/max triple is immutable threading, not mode-enforced `di`/`uo` uniqueness. —
    *Opus + Codex.*

16. **Puzzles that hand over the full implementation.** `puzzles/concurrent/02-pipeline`
    prints all three stages in the prompt → transcription, not design. — *Opus + Codex.*

17. **Prerequisite notation is inconsistent and one link is broken.** `Prerequisites:` /
    `After:` / `Requires:` used interchangeably; `bridge/README.md:25` points to
    `katas/foundations/07-io-error-handling` which is actually `07-exceptions`. — *Opus
    (broken link) + Ring (notation). Verified.*

---

## 3. Contested / adjudicated — read the ruling, not the loudest reviewer

### 3.1 `solutions/2` "sorts and removes duplicates" — **Codex is WRONG; the doc is correct**

`koans/determinism/02-nondet-in-det/solution/README.md` says `solutions/2` returns a sorted
list with duplicates removed. Codex flagged this as a technical error ("can't sort an
unorderable type"). **That is the one outright-incorrect claim across all 17 reviews.**
Mercury has a *universal standard order of terms* (builtin `compare/3`, defined for every
type via RTTI), and `solutions/2` is documented to return sorted, de-duplicated results —
which is precisely why `unsorted_solutions/2` exists separately. **Ruling: leave the doc as
is.** (Optional: add a pointer to `unsorted_solutions/2` as the order-preserving variant.)
Do **not** apply Codex's recommended fix — it would introduce an error.

### 3.2 Bidirectional-search if-then-else determinism explanation — **misleading; fix**

`puzzles/advanced/03-bidirectional-search/solution/README.md` claims a nondet generator in
an if-then-else condition makes the predicate `nondet` because nondet "propagates upward
before committed-choice reduction." Opus says this contradicts Mercury's semantics (the
condition is a single-solution/soft-cut context, so the construct is *semidet*); Ring
reached the same suspicion but never committed; Codex flagged it but with a muddled
`cc_*`-effect rationale. **Ruling: the explanation is misleading and should be reworded** to
Mercury's commit-on-condition rule — but **confirm against `mmc` first**, since determinism
edge cases deserve a compiler check before rewording. The recursive-scan source is fine
either way.

### 3.3 Bridge 05 `(out,out) is nondet` explanation — **imprecise; tighten**

Opus and Codex find "the set is infinite, so there's no finite way to enumerate it" and "a
nondet mode is not the same logical object" misleading (infinite nondet generation is
normal; determinism is a property of a calling mode, not the relation). **Ring explicitly
marked this explanation correct.** **Ruling: tighten it** — the real points are (a) an
unbounded generator needs a deliberate enumeration order, and (b) `promise_equivalent_clauses`
requires proving relation equivalence. Lower priority than §3.2.

### 3.4 Unused imports — **Codex/Ring over-flagged; only three are real**

Codex and Ring listed `list`/`string` unused in the concurrent pipelines and `string`
unused in `crypto.m`. **Those are wrong** — all are used by `io.format` (`[...]` needs
`list`; `i()`/`s()` need `string`). **Ruling: the only confirmed unused imports are `maybe`
in `memoized_search.m` and `char` in `anagrams.m` and `csv_reader.m`.** Add a *tool-driven*
unused-import check rather than working from the review lists.

### 3.5 Overall severity — **Codex over-weights, Ring under-weights**

Codex's 6/10s treat the navigation + contract issues as nearly disqualifying; Ring's 8/10s
under-weight real bugs it missed. **Ruling: ~7/10 overall** — a strong curriculum with a
short, concrete blocker list, not a troubled one.

---

## 4. Already addressed — do NOT re-action

Several review items predate recent edits and are already fixed; re-doing them wastes effort:

- `combinators.m` `choice_det` now carries a comment explaining `Q` is unreachable. *(Codex/Ring
  flagged the missing explanation.)*
- `sudoku.m` `get_nth` now has a comment documenting the out-of-bounds safety precondition.
  *(Extend to `set_cell`/`set_nth`/`get_row` — those are still bare.)*
- `parallel_sort.m`'s "unreachable" merge branch now has an explanatory comment.
- `puzzles/concurrent/02-pipeline` "Why Mercury" was rewritten to be specific (`!IO`
  uniqueness, `channel(T)`, `maybe` sentinel) — addresses the earlier "too generic" note.
- `csv_reader.m` strip-policy now has a good design comment (the *failure* contract still needs one).
- Root README track table counts are accurate; advanced/concurrency/tooling indexes are current.
- `katas/advanced/02-solver-types` rewritten from reference-only to a working exercise + koan.

---

## 5. Single-reviewer findings worth keeping

- **Coverage gaps beyond solver types** (Opus + Ring): no multi-module capstone; partial
  application/currying and impure-predicate *design* are thin. (Ring's list; Opus seconds the
  capstone.) Lower priority than the blockers.
- **"Any order after the core" is too loose** (Opus + Codex): solver kata needs FFI + trailing
  grade; recommend explicit subpaths.
- **Reactivation front-loads `06-pure-randomness`** (mutables/impurity/FFI) before Foundations
  teaches modules/IO — mark "advanced recall; defer" (Opus + Codex).
- **`meta_interp.m` terse names** (`a`/`n`/`f`/`v`/`c`, `rename_2`, `apply_env_f`) for code
  learners extend (Opus + Codex).
- **Wanted: a concurrency bridge and a tooling-track narrative** (Ring).
- **STM kata lists no prerequisites in its own README** though the track README does (Ring).

---

## 6. Prioritized action backlog

**P0 — release blockers (trust + navigation):**
1. Complete every stale index; fix the `07-io-error-handling`→`07-exceptions` link and the
   root bridge-02 mislabel ("Channel-based concurrent pipelines" → sequential grouping); add
   a CI path/count check. (§1.1, §2.17)
2. Enable CI authoritatively (the workflow is `if: false`) and retire/mark-historical the
   stale `REVIEW.md` ("7 of 41 compile"). Add per-koan expected-diagnostic checks.
3. Fix the four real contract/teaching bugs: bridge 11 read-error propagation (§2.7), bridge
   10 fan-in (§2.8), existential contradiction (§2.9), `nondet_koan.m` double-flaw (§2.10).

**P1 — correctness of reference material:**
4. Reword the bidirectional (§3.2, after `mmc` check) and bridge-05 (§3.3) determinism notes.
5. Fix the parser failure contracts (calculator/CSV/config) and sudoku's collect-all (§2.11–12).
6. Document/enforce `many`/`many_p` progress (§2.13); fix `memoized_search` seed (§2.14);
   make `stats_pipeline` entry-point determinism consistent (§2.15).
7. **Do NOT touch the `solutions/2` note (§3.1).**

**P2 — polish:**
8. Rewrite `FIX:` comments as invariants (§1.4); expand track overviews (§1.5); standardize
   prerequisite notation; add expected-output to more exercises; demote in-prompt full
   implementations to hints (§2.16).
9. Tool-driven unused-import pass (real targets: `maybe`/memoized_search, `char`/anagrams,
   `char`/csv_reader — §3.4); finish documenting sudoku's unsafe index helpers.
10. Per-format README template; meta-interpreter naming; "any order" subpaths; reactivation
    ordering.

**P3 — scope expansion (post-release):**
11. Finite-domain solver engine (`CLP-PLAN.md`); multi-module capstone; concurrency bridge.
