# TODO

Backlog derived from the three-reviewer synthesis (2026-06-19).
Source of truth and full reasoning: [`REVIEWS-SYNTHESIS/SYNTHESIS.md`](REVIEWS-SYNTHESIS/SYNTHESIS.md).
Individual passes in `OPUS-REVIEWS/`, `CODEX-REVIEWS/`, `RING-REVIEWS/`.

---

## P0 — release blockers (trust + navigation)

- [ ] **Complete every stale index.** `katas/README.md` ("More tracks will follow" — 8
  exist), type-system (lists 5/10), parsing (3/9), mode-system (omits 06–07), determinism
  (omits 04–06), foundations (omits 10–11), `bridge/README.md` (lists 4/11),
  `puzzles/README.md` (under-lists concurrent + advanced).
- [ ] **Fix broken/misleading nav.** `bridge/README.md:25` `katas/foundations/07-io-error-handling`
  → `07-exceptions`; root table bridge-02 label "Channel-based concurrent pipelines" →
  it's a sequential filter/map/fold grouping exercise.
- [ ] **Add a CI path/count check** so index drift can't recur.
- [ ] **Make CI authoritative.** Workflow is currently `if: false`; enable it (needs the
  flake SSH input `mise` wired up) and add per-koan expected-diagnostic checks.
- [ ] **Retire stale `REVIEW.md`** ("~7 of 41 compile") — it contradicts the verified-build
  state. Delete or mark clearly historical.
- [ ] **Bridge 11 read-error propagation** — `read_lines` maps `error(_)` → `[]` then
  returns `ok(...)`, contradicting its own io.res decision table. Return `io.res(list(string))`
  and propagate `error(Err)`.
- [ ] **Bridge 10 fan-in loses work** — two workers each send `no` to the shared output; the
  unchanged writer stops at the first. Add a sentinel-counting writer or a merger; Task 4
  supervisor is a stub ("would restart here") — finish it or relabel as a design sketch.
- [ ] **Existential contradiction** — `plugins/solution/README.md` claims existential
  construction isn't available from clause heads, but `koans/advanced/02-existential-escape`
  teaches `'new tagged'(...)`. Use `'new plugin'(...)` or name the specific restriction.
- [ ] **`nondet_koan.m` double-flaw** — `all_factors` passes `list(int)` where `find_factor`
  expects `int`; the type error fires before the intended determinism error. Make it single-flaw.

## P1 — correctness of reference material

- [ ] **Reword bidirectional if-then-else determinism note** (`puzzles/advanced/03-.../solution/README.md`)
  — the "propagates nondet before committed-choice" claim contradicts Mercury's
  commit-on-condition semantics. **Confirm against `mmc` before rewording.**
- [ ] **Tighten bridge-05 `(out,out) is nondet` note** — "infinite, no finite enumeration"
  and "not the same logical object" are imprecise; reframe around enumeration order +
  `promise_equivalent_clauses` requiring proven relation equivalence.
- [ ] **Parser failure contracts** — calculator (`"1 @ 2"` → `yes(1)`), csv_reader (failed
  row = EOF), config_parser (drops malformed lines) silently accept invalid input. Make the
  failure visible in the type/determinism, or name + document the lenient policy.
- [ ] **Sudoku collect-all** — `solutions(solve(P), [S|_])` collects every solution to use
  the first; switch to committed choice. (nqueens' `solutions/2` is correct — it needs the count.)
- [ ] **`many`/`many_p` progress invariant** — loops forever on a non-consuming parser;
  document/enforce "must consume on success."
- [ ] **`memoized_search.m`** — replace the `999999` magic seed (seed from first solution or
  `maybe(pair(...))`); remove the unused `maybe` import.
- [ ] **`stats_pipeline.m`** — use `det` main + `promise_equivalent_solutions [!:IO]` (per
  `pipeline.m`); stop calling immutable threading "unique state."
- [ ] **DO NOT touch the `solutions/2` sort/dedup note** in `koans/determinism/02` — it is
  correct (Mercury's universal term order). Codex's flagged "fix" would introduce a bug.

## P2 — polish

- [ ] Rewrite `FIX:` comments (calculator.m, pipeline.m) as durable invariants, not edit history.
- [ ] Expand the bare track overviews (foundations, determinism, concurrency, advanced) with
  2–3 sentences of arc each; add a "What you are practising" line to katas.
- [ ] Standardize prerequisite notation (`Prerequisites:` vs `After:` vs `Requires:`); add
  STM kata prerequisites to its own README.
- [ ] Demote in-prompt full implementations to optional hints (`puzzles/concurrent/02-pipeline`).
- [ ] Add expected-output blocks to more exercises (STM kata is the model).
- [ ] Tool-driven unused-import pass. Confirmed real targets only: `maybe` in
  memoized_search, `char` in anagrams and csv_reader. (Codex/Ring's list/string/crypto
  claims are wrong — used by io.format.)
- [ ] Finish documenting sudoku's unsafe index helpers (`set_cell`/`set_nth`/`get_row`;
  `get_nth` already done).
- [ ] `meta_interp.m` naming (`a`/`n`/`f`/`v`/`c`, `rename_2`, `apply_env_f`).
- [ ] Recommend explicit subpaths instead of "any order after the core" (solver kata needs
  FFI + trailing grade).
- [ ] Mark `00-reactivation/06-pure-randomness` "advanced recall; defer" or move it.
- [ ] Adopt a per-format README template.

## P3 — scope expansion (post-release)

- [ ] Finite-domain constraint-store engine to make solver types runnable (`CLP-PLAN.md`).
- [ ] Multi-module capstone (interfaces, opaque types, build definition, tests).
- [ ] A concurrency bridge; cover partial application/currying and impure-predicate design.

---

## Done (this session)

- 14 COMPILER-LESSONS koans + 3 katas (Tier 3); `foundations/20-int-comparison-import`;
  `advanced/07-solver-any-inst`; `katas/advanced/02-solver-types` rewritten; `ci.sh` gate;
  GitHub CI workflow scaffold (disabled); Ring review run; Opus 6-review pass;
  three-reviewer synthesis.
- Already-addressed review items (do not re-action): `choice_det` comment, `get_nth` comment,
  `parallel_sort` unreachable-branch comment, pipeline-puzzle "Why Mercury" rewrite,
  csv_reader strip-policy comment, accurate root table + advanced/concurrency/tooling indexes.
