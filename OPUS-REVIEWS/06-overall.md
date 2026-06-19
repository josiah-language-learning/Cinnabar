# Cinnabar final overall assessment

*Reviewed 2026-06-19 by Claude Opus 4.8, synthesizing the five preceding Opus reviews
(README quality, coverage, correctness, code quality, idiomatic Mercury), each based on a
direct read of the current tree.*

## Overall rating: 7/10

Cinnabar is an unusually ambitious, genuinely Mercury-specific post-tutorial curriculum.
It does not stop at syntax or algorithms: its best material teaches the defining parts of
the language — modes, insts, determinism, committed choice, higher-order contracts, DCGs,
purity, concurrency, FFI — as design tools, and asks the learner to *explain* a choice,
not just produce a green build. A learner who works the intended path and engages the
design questions will come out meaningfully more fluent.

It is not yet release-ready as a community reference, for three fixable reasons: the
navigation layer is stale and hides most of the curriculum; a handful of solution
explanations and reference patterns are wrong or contract-violating; and the public CI is
disabled while a stale prior-review document still claims most programs don't compile.
These are editorial/engineering issues, but they matter acutely for a small-language
community that will treat this repo as practical authority.

## 1. Learning path

The four-format arc is coherent and has real pedagogical force: **katas** build one local
habit at a time; **koans** turn a single compiler diagnostic into an explanation of one
violated contract; **bridges** remove blank-page friction by handing over a working
program to extend; **puzzles** combine the pieces into design decisions. The recurrence is
the point — `maybe` appears as a kata, a koan, bridge 01, then evaluators and parsers; the
same is true for determinism, DCGs, and channels. That is how fluency forms rather than
accumulates.

The caveat is discoverability, which I verified directly: the per-track indexes omit large
parts of what exists (`katas/type-system` lists 5 of 10, `katas/parsing` 3 of 9,
`bridge/README` 4 of 11, `katas/README` still says "More tracks will follow" with 8 tracks
present). The intended arc is on disk but invisible to a learner navigating locally. Fix
the map before judging whether learners will experience the path.

## 2. Educational philosophy

The philosophy is coherent and mostly applied: the compiler is feedback, not just a gate;
constrained repetition builds instinct; types/modes/determinism shape design early; working
code is a stepping stone, not an answer to memorize. The "you bring raw material; the heat
does the work" metaphor matches the best designs (the determinism and mode/inst sequences,
the determinism-ratchet and mode-reversal bridges, the meta-interpreter checkpoints).

Application is uneven where the heat is removed: `puzzles/concurrent/02-pipeline` hands over
all three stage implementations, turning design into transcription; bridge 10's supervisor
task supplies only "would restart here." The standard the philosophy implies — specify an
invariant and acceptance criterion, leave the design, then use the solution to explain
trade-offs — should be enforced consistently.

## 3. Difficulty curve

The main curve is well-judged: practical mechanics → compile-time model → grammar/control
flow → runtime/production concerns → integrative puzzles. Three avoidable spikes:

1. `katas/foundations/00-reactivation/06-pure-randomness` introduces mutables, impurity,
   FFI, and initialization before the main Foundations sequence teaches modules and IO.
   Fine as optional recall for an experienced reader; a spike as ordinary early progression.
2. Bridge 10 jumps from a three-stage pipeline to fan-in termination, bounded buffers,
   backpressure, exception transport, supervision, and restart at once — and its solution
   doesn't fully deliver (fan-in can lose work; restart is a stub). Split it.
3. Solver types remain a language-awareness branch (now a real declaration/mode exercise,
   but still no runnable constraint store). Mark it as such or add a small finite-domain
   engine.

## 4. Format coherence

The four formats are distinct in principle and usually in practice. The boundaries to
protect: katas must not become reading-only references; koans must have exactly one primary
diagnostic (`koans/determinism/02-nondet-in-det` currently fails this — a type error fires
before the intended determinism error); bridges must keep the extension bounded and its
protocol specified; puzzles must not contain the full required implementation in the prompt.
The concurrent-pipeline puzzle is closer to a bridge as written.

## 5. Structural issues and connective tissue

Tracks are well-placed; Mode System, Determinism, Parsing, and Concurrency are particularly
well organized. The connective tissue needs work: "any order after the core" is too loose
(the solver kata needs FFI and a trailing grade; concurrency leans on modes/determinism —
recommend explicit subpaths); the repeated `promise_equivalent_*` material needs a stated
progression so it reads as reinforcement; and the root↔bridge-02 mislabel
("Channel-based concurrent pipelines" for what is a sequential higher-order grouping
exercise) damages the map at the worst spot.

## 6. Comparison with other-language exercise repositories

Against a typical Exercism track, Cinnabar is stronger in **concept sequencing and language
specificity** — it repeatedly asks *why* a relation is `semidet`, *why* a value is unique,
*why* a DCG rule changes a caller's determinism, rather than offering isolated problems with
hidden tests. Against language-koans projects, it is stronger in **scale and transfer**:
koans feed into bridges and puzzles where the lesson must be used in a design.

It is weaker than mature versions of either in **operational trust**: incomplete navigation,
a few answer keys with inaccurate or contract-violating claims, parsers that accept
malformed input, and a CI badge that isn't actually running. Mature curricula earn trust
through a predictable artifact contract — every exercise findable, every broken example
failing for the stated reason, every solution building and behaving as documented, and CI
meaning it.

## 7. Release readiness

The Mercury community would respond well to the ambition and the rare depth of mode,
determinism, concurrency, FFI, and tooling material, and to `COMPILER-LESSONS.md`. They
would quickly flag trust problems:

- `.github/workflows/ci.yml:13` has `if: false`, so `ci.sh` is not enforced publicly. The
  local gate is a good start (it compiles expected-good artifacts and expects koans to
  fail), but it should also assert the *intended* error category per koan and run
  behavioural/protocol tests for the concurrent and parser solutions.
- `REVIEW.md` (dated 2026-06-16) still headlines "roughly 7 of ~41 shipped Mercury programs
  compile," contradicting the current verified-build state. Archive it or mark it clearly
  historical.
- Stale indexes plus the solution-note errors (existential contradiction, bridge 10 fan-in,
  bridge 11 read-error swallowing, the bridge-05 and bidirectional determinism wordings)
  make it premature to treat the repo as authoritative.

### Highest-priority fixes before release

1. **Make verification public and authoritative.** Enable CI from a clean checkout, add
   per-koan expected-diagnostic checks and protocol tests, and retire/update `REVIEW.md`.
2. **Repair the learner map.** Complete every index, fix the broken prerequisite
   (`07-io-error-handling` → `07-exceptions`) and the bridge-02 mislabel, and add a
   path-resolution check.
3. **Correct the reference teaching artifacts.** Fix the existential construction
   contradiction, bridge 10 fan-in, bridge 11 error propagation, and the calculator/CSV
   full-consumption contracts; reword the bridge-05 and bidirectional determinism
   explanations. **Do not** "fix" the `solutions/2` sort/dedup note — it is correct as
   written (see the correctness review; this is where I diverge from the prior CODEX
   review).

## 8. Genuine strengths to preserve

- **Mercury specificity.** Modes, insts, uniqueness, determinism, committed choice, grades,
  and `!IO` are first-class topics — the hard, valuable material post-tutorial learners
  actually need and rarely find drilled.
- **The mode/determinism sequence.** From the six categories through higher-order insts,
  multi-mode relations, committed choice, and parallel execution — unusually rich and
  coherent.
- **Bridges as a middle format.** A working program with scoped extensions is the right
  antidote to the toy-to-blank-page jump. Keep it; tighten task boundaries.
- **Compiler literacy.** `COMPILER-LESSONS.md`, the error-oriented koans, and the
  grade/tooling material prepare learners to work independently in a language whose
  diagnostics and build grades are daily practice. This is the most distinctive asset.
- **Ambitious endpoints.** The parser-combinator library, generic parser, typeclass
  refactor, concurrent pipelines, and meta-interpreter give learners something more
  consequential than an endless run of collection exercises.

Cinnabar is close to a standout Mercury resource. Preserve its depth and its respect for
the learner's reasoning; fix the verification, navigation, and contract details — and
verify the one place where a prior reviewer's "fix" would have introduced an error — and
the depth becomes fully trustworthy.
