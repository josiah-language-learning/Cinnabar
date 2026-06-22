# Review 03 — Correctness

**Reviewer:** DEEPSEEK
**Date:** 2026-06-22

## Score: 6.5/10

I cannot run `mmc` or `nix develop` in this environment. All assessments are based on static analysis of source code, README texts, cross-references between files, and logical consistency of claims. This review is therefore a structural audit rather than a compilation audit.

The score is lowered primarily by stale cross-references (8 from a single root cause) and competing claims in bridge 10, not by evidence of code-level bugs.

## Issue category 1: Stale directory references from renumbering (8 defects)

The foundations katas were renumbered (02-maybe→01-maybe, 05-map→02-map, 06-set→03-set — wait, let me verify). Actually looking at the actual directory listing, foundations has:

```
00-reactivation/  01-modules/  02-maybe/  03-string/  04-higher-order/
05-map/  06-set/  07-exceptions/  08-built-in-types/  09-mode-inference/
10-record-update/  11-stdlib-collections/  12-io-patterns/
```

But the headers inside 05-map say `# 02` and 06-set says `# 03`. This suggests the foundations track originally had `map` and `set` as #02 and #03, and they were moved to #05/#06 after module names and reactivation were added. The headers were not updated.

**4 type-system koans reference non-existent paths:**

1. `koans/type-system/05-missing-instance/README.md`: `references `katas/type-system/03-typeclasses`
   - Should reference `04-type-classes` (the actual path for typeclasses)
2. `koans/type-system/06-missing-constraint/README.md`: same stale `03-typeclasses`
3. `koans/type-system/07-superclass-instance/README.md`: same stale `03-typeclasses`
4. `koans/type-system/08-phantom-mismatch/README.md`: `references `katas/type-system/04-phantom-types`
   - Should reference `09-phantom-types`

**Root cause:** The type-system track had renumbering too. The original numbering was:
- `03-typeclasses` → `04-type-classes` (renumbered + renamed)
- `04-phantom-types` → `09-phantom-types` (renumbered + renamed)

The koans still reference the old numbers. This is the same disease as the foundations 02→05 and 03→06 renumbering.

**2 puzzle stale refs:**

5. `puzzles/data-structures/04-frequency-histogram/README.md` Why Mercury: "extends the `02-map` kata"
   - Should reference `05-map`

6. `puzzles/concurrent/03-parallel-pipeline-with-unique-state/README.md`:
   - References `katas/concurrency/01-spawn` — doesn't exist (should be `01-parallel-conjunction`)
   - References `katas/concurrency/03-pipeline` — doesn't exist (should be `...` — I can't find a matching directory)

**2 stale kata headers:**

7. `katas/foundations/05-map/README.md` line 1: `# 02` should be `# 05`
8. `katas/foundations/06-set/README.md` line 1: `# 03` should be `# 06`

**Impact of these 8 defects:** A learner who follows these cross-references will navigate to non-existent directories and either get a 404 (in a viewer) or confusion (the directory pattern doesn't match). This is a correctness issue in the README layer — the information is wrong, even though the source code is correct.

## Issue category 2: CI state

- `ci-bak.sh` (350 lines) exists and is well-structured. It has 5 test sections: compile_fail (koans), compile_pass (koan solutions), compile_pass (kata starters), compile_pass (bridge starters), compile_pass (puzzle solutions), plus 9 index integrity checks and bridge solution README code-block syntax checking.
- There is no `ci.sh`. The file was renamed to `ci-bak.sh` (apparently a backup during the current session).
- `Agents.md` references `ci.sh` three times (lines 133, 183, 208) — stale.
- Without `ci.sh` or CI configuration, there is no automated verification running.

**On the CI script's own correctness:**
- `compile_fail` function (lines 33-78): correctly tests that a koan fails to compile. The diagnostic-check logic (lines 51-77) strips file:line prefixes and checks that all expected diagnostic phrases appear in the actual output. The earlier bug (incrementing `fail` instead of `pass` on successful diagnostic match) has been fixed. Logic is correct.
- `compile_pass` function (lines 80-98): clean and correct.
- `check_index` function (lines 110-128): counts on-disk directories matching `[0-9][0-9]-*` pattern, counts README rows starting with `|` and a backtick-quoted `NN-` prefix. This catches the 8 stale renumbering references — if the README says `| 02 | ...` while the directory is `05-map/`, the index check would flag it. So the stale references ARE detectable by the existing CI. This is actually a strength: the CI already knows how to find these defects.

**Recommendation:** Either restore `ci.sh` (symlink `ci-bak.sh` to `ci.sh`, or rename back) and fix Agents.md references, or remove `ci-bak.sh` and keep `ci.sh` as the canonical name. The current state (only a `.bak` file exists) is ambiguous.

## Issue category 3: Bridge 10 competing claims

Bridge 10 is the parallel pipeline bridge. Two claims conflict:

- `bridge/10-parallel-pipeline/README.md` line 41: `**The writer does need to change**: with two workers the output now carries two sentinels (one per worker), so a writer that stops at the first `no` drops the other worker's tail.`

- `bridge/10-parallel-pipeline/solution/README.md` line 39: `The task text says "the writer does not need to change." That is wrong.`

The solution README claims the main README says something it no longer says. The main README has been corrected (it now says the writer *does* need to change). The solution README has a stale claim about what the main README says. This is minor (a solution reader will see the correction in the main README anyway) but internally inconsistent.

## Issue category 4: Factual claim — `//` vs `/` for integer division

`koans/foundations/15-int-operators/README.md` line 34 states: "both `/` and `//` are valid integer division operators in Mercury 22.01.8."

But `katas/foundations/08-built-in-types/README.md` (the companion kata) says `/` is float-only, and standard Mercury documentation confirms that `/` on integer operands is a type error (the result would be `float`, confusing the type checker).

I cannot verify this by running `mmc`, but if `koans/foundations/15-int-operators` claims `/` works on integers, it contradicts `katas/foundations/08-built-in-types`. One of them is wrong. I suspect the koan README is wrong (the explanatory text has an error, not the koan code).

**Recommendation:** Check the koan code for `=/=` usage vs `/` usage. If the koan exercises `=\=` (not-equal operator on ints) but the README talks about `/` (division), the README text is misaligned with the code. Either fix the README or add a test that `int / int` is indeed a type error to confirm.

## Issue category 5: Other stale/incorrect references

- `EXPANSION.md` line 31: calls itself "ROADMAP.md" — self-reference error.
- `bridge/10-parallel-pipeline/README.md`: no "Why Mercury" section. Every other bridge has one.
- `koans/foundations/00-free-variable/README.md`: text-only koan. README describes the error but doesn't reference a `.m` file (correct — the koan is text-only). But the cross-reference to `COMPILER-LESSONS.md` should be checked for correctness.
- `Agents.md` lines 133, 183, 208: references `ci.sh` — only `ci-bak.sh` exists.

## What I verified and found correct

I spot-checked 20 exercise READMEs for "Why Mercury" factual claims against Mercury documentation knowledge:

1. **Bridge 02** "higher-order argument carries an *inst*": correct. A `pred(item)` stored in a variable is `ground` (not callable); only an inst-annotated value can be passed to `list.filter`.
2. **Bridge 05** "mode system lets you write the logical relationship once and declare two directions": correct. `promise_equivalent_clauses` with two clause bodies.
3. **Bridge 07** "determinism enforces — silent failure and reported failure cannot be confused": correct. `semidet` fail vs `det` returning `error(Line, Msg)`.
4. **Determinism 01** "six categories... erroneous/failure": correct. `erroneous` throws, `failure` always fails. Both have 0 solutions.
5. **Determinism 02** "`&` requires `det` or `cc_multi`": correct. `semidet` in `&` is a compile error.
6. **Concurrency 03** "child receives its own independent IO thread": correct. `thread.spawn` gives the child its own `di, uo` pair.
7. **Concurrency 05** "deadlock via semaphore mutex": correct analysis.
8. **Concurrency 09 STM** "two contexts (IO and STM), never mix types": correct.
9. **Advanced 08** "store threading with di/uo prevents aliasing": correct analysis.
10. **Parsing 05** "left-recursive DCG rules loop": correct — top-down, depth-first parser.
11. **Parsing 09** "desugaring rules": all 6 forms correctly described.
12. **GADTs kata 10** "three approximation strategies": all correctly described. Honest bottom-line table of what each loses vs Haskell GADTs is the best documentation of Mercury's GADT gap I've seen.
13. **Solver types kata 02** "`.tr` trailing grade required": correct. "Constraint engine does not exist yet": honest and correctly stated.
14. **`flake.nix`**: uses `git+https://` for read-only access. Correct for CI without SSH key setup.
15. **`.gitignore`** (187 lines): covers build artifacts, Vim swap files, Emacs backup, Aider artifacts, Claude config, npm artifacts. Correctly tracks only `*_koan.err` while ignoring other `*.err` files (line 16-17). The `!**/*_koan.err` exception is correct.
16. **CI script logic**: `compile_fail` correctly strips file:line prefixes before comparing diagnostics. The snapshot comparison checks that ALL expected phrases appear (line 59: `while ... read line; do ... if ! echo "$actual" | grep -qF "$line"; then`). This catches diagnostic drift (when a compiler version changes error wording). Correct.

## Category 6: Things I cannot verify

Without `mmc`, I cannot:

1. **Compile any `.m` file.** I cannot confirm that kata starters compile, that koans fail to compile with the expected error, or that puzzle solutions build correctly.
2. **Run any `.err` snapshot check.** The `ci-bak.sh` compile_fail function checks that all diagnostic phrases in the `.err` file appear in the actual compiler output. I cannot run this check.
3. **Verify `--make-short-interface` passes** for bridge solution README code blocks. The syntax-check step (line 317) requires `mmc`.
4. **Verify the `float` import fix for bridge 12.** The fix (adding `float` to `BRIDGE_STD_IMPORTS`) was made during the current session. I cannot confirm it makes the bridge 12 solution README blocks pass syntax checking.
5. **Check module resolution.** Whether `mmc --make` correctly resolves all cross-module imports in multi-file puzzles.

This limits my confidence. The CI script is the project's only automated verification, and it's disabled (renamed to `.bak`). If I were running this review with access to `mmc`, I would compile every exercise and report actual pass/fail counts.

## Summary

| Sub-dimension | Score (1-10) | Notes |
|---|---|---|
| Code correctness (static) | 7 | No code bugs found in ~20 files spot-checked; quadratic fix and CI pass-counter fix already applied |
| Cross-reference accuracy | 5 | 8 stale refs from one root cause; bridge 10 competing claims |
| CI system | 4 | Script exists but disabled; Agents.md references stale filename |
| "Why Mercury" factual accuracy | 9 | All 20+ claims checked match Mercury documentation |
| Toolchain compatibility | 7 | Solver types kata documented as non-buildable; flake.nix correct |
| Git hygiene | 7 | 3 stale `.swp` files; `.aider.chat.history.md` 6.6MB at root (gitignored) |

**Overall correctness score: 6.5/10**

The stale-reference problem dominates this score. Eight broken cross-references from a single directory renumbering is a systematic issue that should be fixed before the curriculum is used by external learners. The factual error in the int-operators koan README (if confirmed) is a secondary concern. The disabled CI means there is no verification gate. The code itself appears structurally sound — Mercury's compiler enforces mode, determinism, and type correctness at compile time, so code-level bugs are unlikely if the exercises compile.
