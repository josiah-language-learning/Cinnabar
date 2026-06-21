# TODO

Backlog derived from the four-model quorum synthesis (2026-06-21).
Source of truth and full reasoning: [`REVIEWS-SYNTHESIS/SYNTHESIS.md`](REVIEWS-SYNTHESIS/SYNTHESIS.md).
Individual passes in `QUORUM-REVIEWS/` (Big Pickle, Codex, DeepSeek, Laguna).

**Model-fit tags:**
- `[Opus]` — needs correct Mercury determinism/mode/type reasoning where a wrong fix
  silently propagates an authoritative error. Do these in the nix devShell, compile-verified with `mmc`.
- `[Sonnet]` — mechanical/editorial, clear acceptance criteria.
- `[DeepSeek]` — daily coding & Mercury fixes (79% SWE-bench).
- `[Big Pickle]` — orchestrator tasks, simple edits, script changes, reviews.
- `[User]` — interactive infra (SSH/keys) the model can't do; or needs `nix develop` access.
- `[any]` — any agent can pick it up; no special reasoning needed.

**Effort tags:**
- `{low}` — trivial, no `mmc` needed.
- `{medium}` — straightforward edit; verify with `mmc`.
- `{high}` — concrete refactor with clear acceptance criteria.
- `{xhigh}` — non-local correctness reasoning.
- `{max}` — open-ended research; must compile-fail/compile-pass for *exactly* the intended reason.

**Hard rule for any code/contract item:** work inside `nix develop` and verify with `mmc` —
koans must still fail for the documented reason, solutions/katas/bridges/puzzles must still
compile. "Looks plausible" is not done.

---

## P0 — trust (CI + navigation)

- [ ] `[Big Pickle]` `{medium}` **Fix CI snapshot mismatch to FAIL.**
  `ci.sh:66-74`: when `all_found=false` (diagnostic differs), it prints `PASS (broke, diagnostic
  differs...)` and still increments `pass`. Change to increment `fail`/append to `failures`, same
  as a compile-PASS error. Either regenerate stale `.err` snapshots or remove the check. This
  undermines CI's claim to verify diagnostics. *(Codex P1→P0; SYNTHESIS §3.1)*

- [ ] `[Big Pickle]` `{medium}` **Fix Bridge 12 snippet CI failures.**
  `ci.sh §6` — expand the heuristic import set to cover `float` (and any other missing module
  used by bridge snippets). Verify all 12 bridges pass `ci.sh §6` cleanly. The current fallback
  `BRIDGE_STD_IMPORTS` omits `float`; Bridge 12's `float`-using snippets fail. Either expand
  the static set or improve the import auto-detection. *(DeepSeek P0; SYNTHESIS §3.3)*

- [ ] `[Big Pickle]` `{low}` **Narrow `.gitignore` `!**/solution/*.err`.**
  Remove `!**/solution/*.err` — `compile_fail` never reads `.err` files from `solution/`
  directories (it reads `$dir/$module.err` for koans). The rule is unnecessary and exposes
  transient compiler logs in the worktree. Keep only `!**/*_koan.err`. *(Codex P1; SYNTHESIS §3.2)*

- [ ] `[User]` `{low}` **Enable CI workflow.**
  GitHub Actions workflow is `if: false`. Enabling it needs the flake SSH input `mise` wired
  up. Interactive infra — agent cannot do. *(Carried from old TODO.)*

- [ ] `[User]` `{low}` **Run `ci.sh` inside `nix develop` and verify.**
  All editorial fixes from old TODO are applied. Run the full gate and confirm clean pass
  (after P0 items 1–3 above). *(Carried from old TODO.)*

## P1 — correctness + documentation

- [ ] `[Sonnet]` `{medium}` **Bridge "Why Mercury" sections: add to bridges 01–03, 07–09, 12.**
  Every bridge should name the checked property Mercury enforces. Follow bridge 05's format:
  "One logical relation with two checked directions." Bridges 01–03, 07–09, and 12 currently
  lack mechanism-specific framing. *(All 4 models; SYNTHESIS §1.4)*

- [ ] `[Sonnet]` `{low}` **Root README "any order" → sub-path recommendations.**
  Line 27: replace "Tooling, Concurrency, and Advanced can be taken in any order" with
  concrete ordering: "Recommended: Tooling → Concurrency → Advanced; Advanced 01 (FFI) → 02
  (solver) → 03–07 (any order)." *(All 4 models; SYNTHESIS §1.5)*

- [ ] `[Sonnet]` `{medium}` **Reactivation sub-katas 02–07: add individual READMEs.**
  Each of `00-reactivation/02-maybe/` through `07-*` needs a one-pager explaining what is
  being reactivated and why. `01-hello-world` is the template. *(DeepSeek P1; SYNTHESIS §2.11)*

- [ ] `[Sonnet]` `{low}` **Bridge 10 README: choose "lost-work" semantics explicitly.**
  The puzzle README currently uses both "at-least-once" and "lost-work." State "lost-work
  semantics (items in flight when a worker crashes are not retried)." *(BP + Laguna; SYNTHESIS §3.4)*

- [ ] `[User]` `{low}` **Verify error-message quoting in koan READMEs against actual `mmc`.**
  Some koan READMEs paraphrase compiler output rather than quoting verbatim. Run koans through
  `mmc` in the dev shell and update any paraphrased quotes to verbatim transcripts. *(Laguna;
  SYNTHESIS §3.5)*

## P2 — polish

- [ ] `[Sonnet]` `{low}` **Link TEMPLATES.md from track READMEs.**
  Add a "see `docs/TEMPLATES.md` for the canonical section order" note in each track/format
  README. *(Laguna; SYNTHESIS §1.9)*

- [ ] `[Big Pickle]` `{low}` **Fix parser quadratic append.**
  `parser.m:28-35`: `Acc ++ [Key - Val]` → `[Key - Val | Acc]` with a single `reverse` on
  success. Verified vs. `mmc` — the result type is `assoc_list(string, string)`, order
  doesn't matter for semantics, only for iteration order. *(Codex; SYNTHESIS §2.15)*

- [ ] `[Sonnet]` `{low}` **Document generic printer `canonicalize` erasure.**
  Add a note in the solution README explaining that `canonicalize` strips type-name
  information from functors, so `yes(yes(42))` prints as `yes/1`. *(Laguna; SYNTHESIS §2.13)*

- [ ] `[Sonnet]` `{medium}` **Meta-interpreter: add concrete failure demo for depth version.**
  The counter-based freshness fix is implemented and correct. But the puzzle README presents
  the depth version as the starting point without a test demonstrating the failure. Either
  (a) add a capture-the-variable regression test that fails under depth, or (b) use the counter
  version as the default and demote depth to a "why this matters" sidebar. *(Laguna; SYNTHESIS §2.14)*

- [ ] `[Sonnet]` `{medium}` **Add "Why Mercury" framing to determinism kata READMEs.**
  At minimum, each determinism kata should open with: "In most languages determinism is a
  runtime property; in Mercury it is a compile-time contract." Extend to other kata tracks
  as time permits. *(DeepSeek; SYNTHESIS §2.16)*

- [ ] `[Opus]` `{high}` **`combinators.m:28`: replace `fail` body with empty body.**
  `empty(_, _, _) :- fail.` → `empty(_, _, _).` with `:- mode empty(out, in, out) is failure.`
  The empty body signals "defined to have no solutions"; `fail` signals "computes `fail`."
  Verify the solution still compiles and the determinism error fires. *(All 4; SYNTHESIS §1.6)*

## P3 — scope expansion (post-release)

- [ ] `[Opus]` `{xhigh}` **Function-vs-predicate kata or bridge.**
  Design an exercise where the learner must choose between function and predicate form for the
  same logic, and the choice affects mode/determinism inference or composability. Bridge 12
  (currying) partially covers this; a dedicated exercise would close the gap. *(DS, Laguna)*

- [ ] `[Opus]` `{high}` **IO design patterns kata.**
  Cover `io.file` reading, `io.res` error handling, reading lines into a list. Currently
  only in bridge 11's solution notes. A kata would make this first-class. *(DeepSeek)*

- [ ] `[Opus]` `{xhigh}` **Mutable state kata (`store`/`store_mutvar`/`io.mutvar`).**
  The only mutable-state exercise is `00-reactivation/06-pure-randomness`. A kata covering
  threaded mutable state with `store_mutvar` and `io.mutvar` would address a real Mercury
  pattern. *(DS, Laguna)*

- [ ] *(see `CLP-PLAN.md`)* **Solver types / CLP(FD) engine.**
  The solver-types kata is correctly marked conceptual-only. `CLP-PLAN.md` tracks the
  ecosystem path. No curriculum action needed beyond what the kata already does. *(Carried.)*

## Advisory (no effort required, awareness only)

- [ ] `[any]` **DO NOT touch `solutions/2` sort/dedup note.**
  `koans/determinism/02-nondet-in-det/solution/README.md` — Mercury's universal term order
  guarantees sorted, deduplicated results from `solutions/2`. This is correct. Codex's earlier
  flagged "fix" would introduce a bug. *(Old TODO, reaffirmed by synthesis.)*
