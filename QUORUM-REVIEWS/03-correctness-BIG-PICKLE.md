# Review 03 — Correctness

**Reviewer:** BIG-PICKLE
**Date:** 2026-06-22

## Overall Assessment

This review evaluates whether the Mercury code in solutions, starters, and koans is correct — that it compiles, matches declared modes/determinisms, produces correct output for all inputs, and doesn't rely on undefined or implementation-specific behavior.

**Critical caveat:** I cannot run `mmc` or `nix develop` in this environment. All assessments are based on static analysis of the source code read during review. The CI script (`ci-bak.sh`) and koan `.err` snapshot comparison mechanism provide reasonable confidence that the compilation status is deliberately maintained, but I cannot verify actual compilation.

---

## What Can Be Verified Statically

### Known Bug: Bridge 12 `float` Import (FIXED)

The Bridge 12 solution `README.md` code-block syntax checker (`ci-bak.sh` lines 240-241) had `BRIDGE_STD_IMPORTS` defined as:

```bash
BRIDGE_STD_IMPORTS="io, int, string, list, maybe, char, bool, exception, require"
```

But the bridge 12 currying-and-impurity solution README has code blocks that use `float` literals (e.g., `scale(2.0)`, `clamp(0.0, 1.0)`). The `float` module needs to be imported for `float` arithmetic operations. The original `BRIDGE_STD_IMPORTS` was missing `float`.

This was fixed during the current session: `float` was added to the comma-separated list on line 240 of `ci-bak.sh`.

**Status: RESOLVED**

### Known Bug: Quadratic Append in Puzzle 08 Parser (FIXED)

The puzzle `advanced/08-multi-module-config/solution/parser.m` used:

```mercury
Acc ++ [Key - Val]
```

This is O(n²) per append — each `++` walks the entire left accumulator to copy it before consing the new pair. The fix was:

```mercury
[Key - Val | Acc]
```

with a `list.reverse` at the end when the result is returned. This is the standard Mercury idiom for linear-time list accumulation.

**Status: RESOLVED**

### Known Bug: Parser `compile_fail` Snapshot Mismatch (FIXED)

The original `ci.sh` had a bug in `compile_fail` (line ~68) where a successful compile_fail diagnostic match incremented `fail` instead of `pass`:

```bash
if $all_found; then
    echo "  PASS (broke as expected, diagnostic confirmed): $label"
    ((fail++))    # BUG: should be ((pass++))
```

This meant CI could report "0 passed, N failed" even when all koans broke correctly with matching diagnostics. The test *functionally* still works (it checks the right thing), but the summary numbers are misleading.

**Status: RESOLVED**

---

## Static Analysis Findings

### 1. All starter `start.m` files use correct Mercury syntax

I reviewed ~15 representative starter files across foundations, determinism, mode-system, and advanced tracks. All use:
- Correct module/interface/implementation structure
- Valid mode and determinism annotations
- Standard library imports consistent with their usage
- No runtime-only constructs in compile-time positions

No syntax errors or obviously mis-typed identifiers were found.

### 2. Koan `.err` snapshots match their `_koan.m` files structurally

The koan approach (deliberate compile-fail) means the `.err` file is a snapshot of expected diagnostic phrases. I checked a sample of 10 `.err` files against their corresponding `_koan.m` sources to verify:
- The error type mentioned in `.err` corresponds to the deliberate mistake in `_koan.m`
- File/line prefixes are stripped correctly by the CI strip rule (`s/^[^: ]*:[0-9]*: *//`)
- No stale `.err` files for koans whose code has changed

**Sample findings:**

- `koans/types/00-free-variable/free_variable_koan.err` — matches the "free variable in function symbol" error. The `_koan.m` uses a constructor in a context where Mercury expects a bound variable. Correct.

- `koans/modes/00-inst/inst_koan.err` — matches the "expected inst" error from mis-moding a predicate call. The `_koan.m` passes a `ground` where a `bound(...)` inst is expected. Correct.

- `koans/determinism/00-det/det_koan.err` — matches the "determinism declaration mismatch" error where a loop is declared `det` but is actually `nondet`. Correct.

### 3. Bridge solution snippets in `solution/README.md` code blocks

The CI script extracts each ` ```mercury ` block from bridge solution READMEs and compiles them with `mmc --make-short-interface` to verify syntax and declaration well-formedness. The blocks are fragments (they reference types defined in the bridge starter), so full type-checking isn't possible, but the syntax check catches declaration-level errors.

The `float` fix mentioned above was specifically about making these bridge snippet compilations pass.

### 4. Stale cross-references: correctness vs. accuracy

The 8 stale cross-references found in README files (foundations 05-map says `# 02` instead of `02-maybe`, etc.) are incorrect in a *referential* sense — a learner following the reference will be confused — but they don't affect code correctness. I flag them in the README quality review.

---

## Potential Issues (Unverified)

### 1. The `det` subset of `cc_multi` in `main/2`

Determinism kata 02 (committed-choice) exercise 2 notes that `main` declared as `is det` compiles because `det` is a subset of `cc_multi`. This is correct according to Mercury's determinism lattice: `det < cc_multi < multi` (det is a subset of cc_multi, which is a subset of multi). The exercise correctly notes this.

### 2. `promise_equivalent_solutions` scope usage

Determinism kata 02 exercise 3 and determinism kata 07 both use `promise_equivalent_solutions`. The kata correctly states that the compiler does not verify the claim — the programmer takes responsibility. The kata includes both a correct use (all solutions return the same value) and a lying use (different values at runtime). This is correct pedagogy; the lying case compiles but has undefined behavior.

### 3. Bridge 03 DCG rule ordering

Bridge 03 (dcg-extend) Task 2 notes that the `float_tok` DCG rule must come *before* the `int_tok` rule, or `"3.14"` tokenizes as `[int_tok(3), dot_tok, int_tok(14)]`. This is correct for `semidet` DCG rules where first-match-wins semantics apply. The solution README presumably handles this — I didn't verify the solution file directly.

### 4. Bridge 04 `&` operator on `det` wrappers

Bridge 04 Task 2 uses `&` to parallelize search across three `colorings_with_c1` calls, which are `det` because they wrap `nondet` generators in `solutions/2`. The bridge correctly notes that `&` requires `det` and would not work on the naked `nondet` generator. The cross-reference to COMPILER-LESSONS.md for known `&` backend limitations is appropriate.

### 5. Bridge 12 impure mutable — correct composition analysis

Bridge 12 Task 4 asks the learner to try calling `impure bump_count` from a pure `list.map` transform and watch it fail. The described behavior (Mercury rejects impurity in pure contexts) is correct. The two resolutions (quarantine with `promise_pure` vs. pure accumulator threading) are both correct approaches, and the bridge's preference for the pure version is sound.

### 6. Advanced 08 — `store(S)` uniqueness threading

The kata's explanation of `di`/`uo` threading for `store(S)` is correct. The sample error message shown (unique-mode error about clobbering a live variable) is accurate. The `<= store.store(S)` constraint on helper predicates is correctly described as the typeclass constraint that makes `get_mutvar`/`set_mutvar` type-check for the abstract `S`.

---

## Concerns

### 1. `.tr` grade for solver type kata (advanced/02)

The solver types kata is documented as non-working because it requires a `.tr` grade (trail) that the project's `flake.nix` provides `asm_fast.par.gc.stseg` (parallel, GC, no trailing). This is acknowledged in the README as a reference kata. This is acceptable for pre-alpha — the concept is documented even though it can't be built — but it should be called out in the project status. The `flake.nix` could add a `.tr` grade shell or at minimum the README could document how to build it manually.

### 2. `mmc --make-short-interface` for syntax checking

The CI script uses `mmc --make-short-interface` for bridge solution code-block parsing. The comment on line 314-316 of `ci-bak.sh` explicitly notes: "`--make --errorcheck-only` is rejected by mmc as a conflicting combination." The current approach parses and checks declaration well-formedness but doesn't type-check references to external predicates. This is an honest limitation — there's no better option in the Mercury toolchain. The CI correctly documents what it's actually checking.

### 3. No module-level name collision check

With ~170 `.m` starter/solution files across the project, there's a risk of module name collisions. `mmc --make` resolves modules by file path, but if two files share the same module name, the behavior depends on build order. I spot-checked for duplicate module names:
- `bridge/02-pipeline-extend/pipeline.m` and `bridge/10-parallel-pipeline/pipeline.m` — both define module `pipeline`. This is fine because they're in separate directories and `mmc --make` resolves by path, but a learner who copies one file to another directory without changing the module declaration will get confusing errors.
- Several modules named `start` across kata directories — by convention, each kata has `start.m` with module `start`. This works because `mmc --make start` is run from each kata's directory, and there's no cross-directory dependency.

This is fine in practice but fragile: if a puzzle or bridge tries to `use_module` a kata's `start.m`, it would need the correct path.

---

## Summary

| Dimension | Score (1-10) |
|-----------|-------------|
| Starter code correctness | 9 |
| Solution code correctness | 8 (unverified: can't compile) |
| Koan diagnostic accuracy | 9 |
| Bridge snippet syntax | 9 (after float fix) |
| Cross-reference accuracy | 6 |
| CI script correctness | 8 |
| Toolchain compatibility | 7 (solver type kata broken) |

**Overall correctness score: 8/10**

Three known bugs were already fixed. The remaining concerns (solver types kata, module name collisions, CI's short-interface limitation) are acknowledged in the documentation. The `.err` snapshot mechanism is a genuinely robust approach to maintaining correctness in a compile-fail test suite. The biggest correctness risk is the unverified state: without running `mmc` against the full project, I cannot confirm that project-wide refactors haven't broken cross-module dependencies.
