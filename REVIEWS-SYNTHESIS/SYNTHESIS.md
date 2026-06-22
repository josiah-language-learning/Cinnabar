# Cinnabar quorum synthesis — 2026-06-22

Synthesized from the current Big Pickle, DeepSeek, Opus, and Codex review sets in
QUORUM-REVIEWS/. Compiler-backed evidence takes precedence over static claims.

## Executive assessment

Cinnabar is a strong Mercury curriculum with a coherent four-format learning model,
substantial compiler-error practice, and unusually deep modes, determinism, parsing, and
concurrency coverage. This cycle found no broad standard-grade source-build failure among
runnable targets. The blocking work is operational and connective tissue: the canonical
CI entrypoint is missing from this worktree, eight koan diagnostic fixtures drifted, four
prerequisite links are dead, and several README-required grades are absent from the
declared development shell.

Adjudicated score: 8/10. Prioritize correctness and navigation hardening before
adding more exercises.

## Adjudicated evidence

Question                       Result
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Kata starters                  71/71 compile at asm\_fast.par.gc.stseg
─────────────────────────────  ─────────────────────────────────────────────────────────────────────────
Bridge starters                12/12 compile at asm\_fast.par.gc.stseg
─────────────────────────────  ─────────────────────────────────────────────────────────────────────────
Executable puzzle solutions    21/21 compile at asm\_fast.par.gc.stseg
─────────────────────────────  ─────────────────────────────────────────────────────────────────────────
Executable koan solutions      84/84 compile at asm\_fast.par.gc.stseg
─────────────────────────────  ─────────────────────────────────────────────────────────────────────────
Intentionally broken koans     Still fail as intended; eight snapshots have secondary diagnostic drift
─────────────────────────────  ─────────────────────────────────────────────────────────────────────────
Kata feedback loops            Every kata starter has runtests; the claimed test-script gap is false
─────────────────────────────  ─────────────────────────────────────────────────────────────────────────
Canonical CI command           Broken in this worktree: ci.sh is deleted while ci-bak.sh is untracked

### Claims rejected by this synthesis

- Do not add kata test scripts as a response to this review; they already exist.
- Do not replace empty(_, _, _) :- fail. in the combinator library. Compiler verification
shows the fail goal is required for its declared mode.

- The foundations 05-map/06-set issue is title/directory-number drift, not broken
prerequisite links.

- The bridge snippet gate checks syntax/declarations only; it cannot establish surrounding
type, mode, or determinism correctness.

## Strengths to preserve

1. The kata → bridge → puzzle → koan model provides drill, guided extension, open
synthesis, and compiler-error literacy rather than one repetitive exercise style.

2. The mode and determinism tracks are the curriculum's strongest technical sequences.
3. Koans plus COMPILER-LESSONS.md make the compiler a deliberate teaching tool.
4. Current coverage is broad: further content should focus on package-scale workflow,
standard-library judgment, and cross-track retrieval.

## Action backlog

### P0 — restore trust

1. Restore one canonical CI executable. Restore ci.sh, or deliberately rename it
and update Agents.md, the workflow, and all documented commands atomically.
[any] {low}

2. Regenerate eight drifted koan .err snapshots with the pinned Mercury compiler:
advanced/01-ffi, concurrency/01-parallel, foundations/01-maybe,
foundations/05-exceptions, foundations/06-file-io,
foundations/12-map-io-capture, mode-system/03-higher-order-inst, and
type-system/01-adt. [Opus] {medium}

3. Make README-required grades truthful. Provision the serial, profiling, and
non-parallel grades, or state clearly that the affected workflows require another
installation. [User] {high}

### P1 — navigation and first-contact polish

4. Fix four dead type-system koan prerequisites. Replace 03-typeclasses with
04-type-classes in three koans, and 04-phantom-types with 09-phantom-types in
08-phantom-mismatch. Add a local-path-reference CI check. [Sonnet] {low}

5. Align foundations titles and headings. Correct the 05-map/06-set title numbers
and standardize inline **Concept:** sections to ## Concept. [Sonnet] {low}

6. Complete Bridge 10's framing. Add “Why Mercury,” remove its self-stale solution
note, and explicitly state its lost-work semantics. [Sonnet] {low}

7. Add duration bands (short, medium, long) to indexes and exercises.
[Sonnet] {medium}

### P2 — verification and transfer

8. Audit bridge snippets semantically. The current short-interface gate missed a
Bridge 04 determinism bug; compile representative snippets as self-contained modules
with stubs where necessary. [Opus] {high}

9. Add end-of-track retrieval prompts and one annotated worked example per track.
Name the reactivation predict-verify transition in START-HERE.md. [Sonnet] {medium}

10. Add a COMPILER-LESSONS.md TOC and low-cost hygiene checks (supported warnings,
shell syntax, and local-link checks). [any] {medium}

### P3 — selective expansion

11. Add a package/build-system kata or bridge: interfaces, dependency direction,
multi-module mmc --make, and refactoring. [Opus] {high}

12. Add a standard-library decision guide covering cord, foldl2, map_foldl,
use_module versus import_module, and output formatting. [Sonnet] {medium}

13. Add thin “Paradigm Note” callouts only where they clarify a Mercury invariant.
[Sonnet] {medium}

## Reviewer calibration

- Compiler-backed findings are authoritative for Mercury semantics and path claims.
- Big Pickle and DeepSeek were useful for prose and coverage, but their claims that most
kata tests are absent and that foundations prerequisite paths are dead were disproved.

- Opus supplied the strongest correctness evidence, including the Bridge 04 determinism
defect fixed during this cycle and the missing-current-worktree ci.sh regression.

- Codex's operational audit was useful; its initial toolchain limitation was resolved via
the documented prebuilt dev-shell revision.

## Exit criteria for the next cycle

The next synthesis should verify that the documented CI command runs, all eight snapshots
match, every README local path resolves, and every special-grade exercise has an explicit
available/unavailable status.

