# TODO

Remaining work after the 2026-06-17 fix sweep (36 source files, 20 READMEs corrected).
Items are P0 unless marked otherwise.

---

## Ring review action items (2026-06-18)

Five Ring reviews completed. Items below are in priority order from the review synthesis.

### Bugs / factual errors

- [x] **Sudoku prerequisite wrong** — `puzzles/logic/01-sudoku/README.md` lists
  `katas/foundations/05-map` for `set(T)`. Should be `katas/foundations/06-set`.

- [x] **`div_safe` / `num_div` name mismatch** — `bridge/09-typeclass-refactor/README.md`
  says `func div_safe(N, N) = maybe(N)` but `bridge/09-typeclass-refactor/solution/README.md`
  uses `num_div`. Rename one to match the other.

- [x] **`with_inst` red herring in bridge/06** —
  `bridge/06-pipeline-parameterization/README.md` task 3 suggests a
  `:- type filter_pred == (pred(item) with_inst ...)` type alias that the solution
  silently abandons. Either confirm it doesn't compile and remove the suggestion, or
  show the correct approach.

### Structural gaps

- [x] **Koan solution audit** — verify every koan directory has a `solution/` subdirectory
  with at least a solution README. Flag any that only have the problem README.
  Result: 28 koans checked; only `koans/tooling/01-grade` was missing. Created
  `solution/README.md` (text-only koan, no source file).

- [x] **Difficulty scaffolding for puzzle 07 (meta-interpreter)** — add "Part A / Part B"
  decomposition or intermediate milestones to
  `puzzles/advanced/07-mercury-in-mercury/README.md`. Ring called the jump "a massive leap."

- [x] **Difficulty scaffolding for puzzle 03 (bidirectional search)** — similar treatment
  for `puzzles/advanced/03-bidirectional-search/README.md`.

- [x] **Advanced kata track thinning** — `katas/advanced/02-solver-types` has no working
  build; ring flagged the track as "insufficient preparation." Either fix the solver-types
  kata or add 2–3 more katas before the advanced puzzles.
  Actions: (1) added `04-pragma-memo` to track README (it existed but was unlisted);
  (2) fixed puzzle 05/06 wrong `katas/typeclasses/` prereq paths → `katas/type-system/`;
  (3) wrote new kata `05-assoc-list-env` (assoc lists as environments, deref chains,
  let-evaluator — the exact idiom meta-interpreter uses); compiles and test harness runs.

### Content improvements

- [x] **Sudoku approach over-scaffolds** — `puzzles/logic/01-sudoku/README.md` gives the
  full `fill_first_empty` skeleton. Replace with a conceptual description that leaves the
  recursion pattern to the learner.

- [x] **Bridge READMEs missing "Why Mercury"** — add a brief Why-Mercury paragraph to
  bridge/04-determinism-ratchet, bridge/05-mode-reversal, and bridge/06-pipeline-
  parameterization. Puzzles have these; bridges don't.

- [x] **Koan READMEs too sparse** — add 1–2 sentences per koan explaining *why the broken
  concept matters*, not just "fix it." Audit all koan READMEs.
  Result: 5 of 28 were missing `## What to observe` and `## Your task` sections:
  advanced/02-existential-escape, concurrency/02-shared-state,
  mode-system/04-uniqueness-violation, parsing/03-dcg-mode, tooling/02-module-name.

- [x] **Design questions inconsistent** — add design questions to puzzles/bridges that
  currently lack them: Sudoku, concurrent pipeline (02), mode reversal bridge (05).

### Code quality (minor)

- [x] **`anagrams.m` has zero comments** — add a brief algorithm comment (canonical form =
  sort chars; group by canonical).

- [x] **`bidir.m` float precision** — `is_perfect_square` uses `float.sqrt` and rounds;
  acknowledge the precision limitation in a comment or use an integer-only method.

- [x] **`sudoku.m` silent failure** — `get_nth` returns 0 for out-of-bounds; add a comment
  noting this is intentional for the demo or use `det_index1/3`.

- [x] **`choice_det` needs a comment** — in `combinators.m`, note that `choice_det` commits
  to the first alternative without backtracking (unlike Prolog choice).

### Coverage gaps (P1 — new content, not urgent)

- [ ] **STM coverage** — `stm` module / `atomic/2` completely absent from curriculum.
  Consider a concurrency kata or koan.

- [ ] **Solver types** — `advanced/02-solver-types` is a broken reference kata. Either get
  it working or replace with a proper kata (or at least a working koan).

- [ ] **Property-based testing** — no coverage. Consider a tooling kata.

---

## Source files

### `puzzles/parsing/01-calculator/solution/calculator.m` — DONE

Full DCG rewrite completed 2026-06-17:
- Removed `import_module dcg`
- `phrase(tokens(Tokens), Chars)` → `tokens(Tokens, Chars, _)`
- All multi-clause DCG predicates rewritten with if-then-else
- `F =\= 0` → `F \= 0`
- `tokenize` declaration updated to `is det`

### `puzzles/data-structures/02-expression-evaluator/solution/expr_eval.m` — DONE

Removed dead `:- import_module string.` (2026-06-17).

---

## Cosmetic / low-priority — DONE

- `katas/foundations/04-higher-order/README.md` — Steps 2–4 already have explicit "in
  main(!IO)" framing from the earlier fix sweep. No further change needed.
- `katas/type-system/04-type-classes/README.md` — comment capitalisation fixed
  (`% what you might want...`) 2026-06-17.

---

## Structural / future work (not urgent)

From REVIEW.md recommended fix order — not yet started:

1. **CI gate** — script that compiles every `.m` file; koan solutions + puzzle solutions +
   bridge starters must pass; broken koan files must fail for the documented reason only.
2. **Kata `start.m` skeletons** — DONE (2026-06-18). All tracks complete:
   foundations 00–09, type-system 01–05, determinism 01–04, mode-system 01–05,
   parsing 01–03, concurrency 01–03 (`.par` grade noted in runtests), tooling 01–05
   (01 and 02-solver-types are reference-only with marker runtests, 02-mdb gets
   `buggy_index.m`, 03-profiling gets `fib_profile.m`), advanced 01–04.
3. **`koans/parsing/03-dcg-mode`** — DONE (2026-06-17). Fix sweep had already removed
   `phrase/2` and `import_module dcg`. Remaining cleanup: removed dead if-then-else in
   both `main` predicates (compiler warned "condition cannot fail" since `tokens` is det).

---

## Expansions (new content — see EXPANSION.md for full specs)

Full plan is in `EXPANSION.md`. Execution order is in that file's final section.
Items below are the new content gaps specifically flagged by the code reviews.

### New katas not yet in the repo

| Kata | Track | What it teaches |
|---|---|---|
| `foundations/09-record-update/` | Foundations | `^` field access, `:=` functional update, naming convention |
| `foundations/10-stdlib-collections/` | Foundations | `bag`, `digraph`, `bimap`, `array` vs `version_array` |
| `type-system/05-typeclass-depth/` | Type system | Superclasses, multi-param typeclasses, functional dependencies |
| `tooling/02-trace-goals/` | Tooling | `trace` goals, compile-time flags, pure-safe debug output |
| `advanced/03-global-state/` | Advanced | `:- mutable`, `store`, purity pragmas, when to use each |

### Repetition engineering — DONE (2026-06-18)

All tracks now have `start.m` + `runtests`. New kata content from EXPANSION.md
should follow the same skeleton pattern when added.
