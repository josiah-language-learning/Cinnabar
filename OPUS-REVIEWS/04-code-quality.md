# Cinnabar reference-solution code quality review

*Reviewed 2026-06-19 by Claude Opus 4.8. I read all 20 Mercury modules under
`puzzles/*/solution/` in full. This judges them as reference material learners will
imitate — not whether they compile (they do). Where I re-checked the prior CODEX review's
specific claims, I note agreement and, in a few cases, correction.*

## Overall teaching-code quality: 7/10

The modules consistently use explicit modes, `!`-threaded state, compact pure helpers,
and proportionate section comments. The strongest files make determinism and higher-order
calling conventions *visible*, which is the point of reference code in this language. The
score is held back by a recurring "manufacture `det` by swallowing invalid input" habit in
the parsers, one non-minimal `cc_multi` entry point, an inefficient collect-all-then-take,
a magic sentinel, and two higher-order combinators with no progress invariant.

## Strongest files (study-worthy as-is)

- **`data-structures/02-expr_eval.m`** — reference-quality. `eval` is a pure
  `func(env, expr) = maybe(int)`; `bind_maybe`/`map_maybe` carry failure propagation
  (`:33-46`); division-by-zero and unbound variables are the *only* `no` sources;
  presentation is isolated in `eval_and_print` (`:59-66`). This is the file to point new
  Mercury programmers at.
- **`logic/02-nqueens.m`** — clean `nondet` generator + incremental `semidet` pruning;
  `safe/3`'s `Dist` parameter documents the diagonal invariant (`:26-31`); and it uses
  `solutions/2` *correctly* — it actually needs the full list to count solutions (`:47-49`).
  This is the right foil to sudoku (below).
- **`data-structures/04-histogram.m`** — strong applied stdlib example: fold into a map,
  sort descending for presentation, render bars; `print_bar/6` carries its inputs clearly.
- **`data-structures/03-graph.m`** — shows both a `det` visited-set traversal (`:27-38`)
  and a `nondet` `loop_check` traversal (`:41-47`). The contrast is specifically
  Mercury-ish and worth keeping.
- **`advanced/05-gen_parser.m`** — the newtype-wrapper instances and **precise constraint
  placement** are excellent: `satisfy` carries `<= token_stream(S,T)` because it calls the
  method (`:57`), while `many_p` does *not*, because it only calls its higher-order argument
  (`:63`). The comment explaining this (`:52-55`) is exactly right.
- **`advanced/07-meta_interp.m`** — best-structured large example: clear phase separators,
  accurate determinisms, and the comment explaining `unify_d` is a single if-then-else
  specifically to stay `semidet` (`:62-63`).
- **`concurrent/02-pipeline.m`** — the canonical concurrency entry point: `main/2` stays
  `det`, and `promise_equivalent_solutions [!:IO]` visibly contains the spawned `cc_multi`
  (`:66-70`).

## Issues to fix

### Parsers that swallow invalid input (highest priority)

- **`parsing/01-calculator.m`**: `tokenize/2` is `det` because `token_list/3` returns `[]`
  when `one_token/3` fails (`:37`), and `tokenize` then *discards* the unparsed remainder
  (`tokens(Tokens, Chars, _)`, `:22`). I traced `"1 @ 2"`: it tokenizes to `[int_tok(1)]`,
  drops `@ 2`, and `calculate` returns `yes(1)`. Malformed input is silently accepted as a
  valid prefix. Return a result type, or require full consumption.
- **`parsing/02-csv_reader.m`**: same shape — `parse_csv/3` treats a failed `row` as
  end-of-input (`:30`) and `parse/1` ignores the remainder (`:92`). Unterminated quotes
  become a truncated-but-"successful" CSV. (Its strip-policy comment at `:60-63` is exactly
  the right *kind* of design note — apply the same honesty to the failure contract.)
- **`parsing/03-config_parser.m`**: `parse_lines` silently drops every malformed nonblank
  line (the final `else`, `:51`). Forgiving config can be a deliberate policy, but it needs
  a comment and a test; otherwise it models silent error loss.

### `sudoku.m`

- `main` calls `solutions(solve(Puzzle), [Solution | _])` (`:146`) — collects **all**
  solutions to print the first. Use committed choice (`( solve(Puzzle, S) -> ... ; ... )`)
  for first-solution search. (Contrast `nqueens.m`, which legitimately needs all.)
- Index/update helpers (`set_cell`, `set_nth`, `get_row`, `drop_n`) silently return
  `[]`/`0` out of bounds; their `det` signatures are honest only under undocumented
  representation invariants. **Partially addressed:** `get_nth` now carries a comment
  explaining the safety precondition (`:121-122`) — extend that to the others or isolate
  them as unsafe internal helpers.

### Higher-order combinators with no progress invariant

`advanced/04-combinators.m`'s `many/4` (`:86-95`) and `advanced/05-gen_parser.m`'s
`many_p/4` (`:63-71`) both loop forever if the supplied parser succeeds without consuming
input (`Mid = Input`). The higher-order inst declares success *cardinality*, not *progress*.
Document the "must consume on success" precondition, test an empty parser, or compare
`Mid` to `Input`. **Note:** `combinators.m`'s `choice_det/5` — which CODEX flagged as
ignoring `Q` with no explanation — now carries a comment explaining a `det` parser always
succeeds so the second alternative is unreachable (`:66-67`). That one is addressed.

### `memoized_search.m`

`999999 - []` is used as a minimum-fold seed (`:46`) — an imperative sentinel that also
fails for any path costing ≥ 999999. Pattern-match the first solution as the initial
accumulator, or fold to `maybe(pair(int, list(node)))`. The `maybe` import (`:10`) is
**genuinely unused** — confirmed.

### `stats_pipeline.m`

`main/2 is cc_multi` (`:4`) is non-minimal next to `pipeline.m`'s `det`-main +
`promise_equivalent_solutions [!:IO]` pattern. Use the same containment, or comment why
this module deliberately exposes `cc_multi`. Separately, the comment calling the
count/sum/max triple "the *unique state* of this stage ... the same linearity that
array_di/array_uo enforces" (`:35-38`) overstates: these are ordinary immutable values
threaded through a tail call, *not* mode-enforced uniqueness. Keep the linearity analogy
but stop short of claiming the mode system enforces it.

### `meta_interp.m` naming

The terse constructors `a`/`n`/`f`/`v`/`c` (`:17-23`) and helpers `rename_2` (`:37`),
`apply_env_f` (`:127`) optimize for compactness over readability in code learners will
*extend*. `atom`/`integer`/`compound`/`variable`/`clause` and
`rename_with_suffix`/`apply_env_to_term` would teach better. The depth-suffix renaming is
honestly flagged as not globally fresh (`:97-99`) — keep the warning, and consider fencing
it at `resolve/5` so nobody lifts it as a reusable interpreter core.

## Cross-cutting

### Imports — correction to the prior review

The genuinely unused imports I can confirm by reading are: `maybe` in
`memoized_search.m`, and `char` in both `anagrams.m` and `csv_reader.m` (neither makes any
`char.` call; char literals don't need the module). **However**, the prior review's claims
that `list`/`string` are unused in the two concurrent pipelines and that `string` is unused
in `crypto.m` are **incorrect** — all three are used by `io.format`, whose argument list
`[...]` requires `list` and whose `i()`/`s()` poly-type constructors require `string`. A
mechanical unused-import pass is still worth adding, but it should be tool-driven, not from
that list.

### "FIX:" comments

`calculator.m:18,28,40,64,74,91,107,119` carry `FIX:` comments that narrate a past
compiler fight ("multiple clauses → if-then-else", "=\\= doesn't exist"). In finished
reference code these should be rewritten as durable invariants — e.g. "maximal-munch lexing
expressed as a deterministic conditional chain" — not edit-history. This is the single most
pervasive teaching-comment problem in the corpus. (`parallel_sort.m`'s former bare
"unreachable" fallback now *has* an explanatory comment at `:89` — that one is fixed.)

## Release priorities

1. Fix the calculator/CSV/config full-consumption/error contracts — the most damaging
   patterns to imitate, because they call malformed input "success."
2. Replace sudoku's collect-all with committed choice; remove the `999999` seed; finish
   documenting the unsafe index helpers.
3. Document/enforce the `many`/`many_p` progress precondition.
4. Make the concurrent entry-point determinism consistent; rewrite the `FIX:` comments.
5. Add a tool-driven unused-import check (confirmed targets: `maybe` in memoized_search,
   `char` in anagrams and csv_reader) plus a malformed-input parser test suite.
