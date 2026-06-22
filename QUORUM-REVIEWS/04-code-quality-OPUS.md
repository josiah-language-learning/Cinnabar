# Review 04 — Code Quality

**Reviewer:** OPUS (Claude Opus 4.8)
**Date:** 2026-06-22

## Assessment

Code quality is high, and most of it is *enforced* rather than aspirational: `mmc` rejects
mode, determinism, type, and exhaustiveness errors, so the floor is already above what a
linter buys most languages. The hand-written quality (naming, named fields, explicit
imports, minimal koans) is consistently good. The deductions are hygiene and tooling, not
the exercise code itself.

## Strengths (confirmed by reading ~40 `.m` files this session)

- **Explicit everything.** Modes and determinism are annotated, never left to inference;
  import lists are explicit module-by-module; ADTs use named fields (`coloring(node1::
  color, …)`). This is what you want a *teaching* corpus to model.
- **Koans are minimal and single-purpose.** One deliberate break per file, marked with a
  `BUG`/intent comment. I verified they fail for that reason (see Review 03).
- **The store kata and bridge-04 rewrite are idiomatic.** `<= store.store(S)`-constrained
  helpers and `cc_multi` committed-choice are exactly the right patterns (mmc-verified).

## Weaknesses

### 1. Working-tree hygiene is currently poor
- **`ci.sh` deleted, untracked `ci-bak.sh` in its place** (see Review 03). This is the
  single worst hygiene problem right now — the canonical script is in an inconsistent,
  half-renamed state while `Agents.md` still references `ci.sh`.
- **`.README.md.swp`** (a 20 KB Vim swap file) is sitting in the repo root. Untracked, so
  not committed, but it is cruft a `git clean`/`.gitignore` entry should remove.

### 2. Module-name reuse is broad but mostly benign
`:- module start.` appears 71× and `:- module fixed.` 67× — by directory convention,
fine for `mmc --make` run per-directory. The one worth a note is `:- module pipeline.`
across **4** files (bridges 02 & 10 plus puzzle pipelines): separate build dirs make it
safe, but it is a copy-paste-into-wrong-dir foot-gun and `.gitignore` can only ignore one
`pipeline` binary at root. Low severity.

### 3. CI doesn't lean on the compiler's own quality flags
`--warn-unused-imports` / `--warn-singleton-variables` are not part of the gate. Given the
explicit-imports value the curriculum preaches, wiring `--halt-at-warn` (or at least
surfacing warnings) into the gate would keep the corpus honest as it grows. (Minor — and
moot until `ci.sh` is restored.)

### 4. Comment density varies — mostly by design
Katas carry explanatory comments (~7 in mode-system/05's start.m); koans are near-bare
(~2 in foundations/01-maybe). The variance the other reviewers flag is largely
*intentional* (koans should be minimal). The genuine inconsistency is within the kata
tier, not across tiers.

## vs the other reviewers
DEEPSEEK's code-quality read (combinator library: conflated error cases / dead output) is
the most useful concrete contribution and I defer to it — those are real quality (not
correctness) issues; the file compiles. BIG-PICKLE's `pipeline` collision and `.swp` notes
reproduce. Neither flagged the live `ci.sh`/`ci-bak.sh` split, which outranks all of these.

## Score: **7.5/10**
The exercise code is genuinely high-quality and compiler-honest. Held back today by the
`ci.sh` rename limbo and root cruft (both trivially fixable), plus the combinator-library
quality issues DEEPSEEK catalogued.
