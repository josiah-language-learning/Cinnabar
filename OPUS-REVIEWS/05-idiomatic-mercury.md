# Idiomatic Mercury review of puzzle reference implementations

*Reviewed 2026-06-19 by Claude Opus 4.8. Read all 20 `puzzles/*/solution/*.m` modules.
This asks a narrower question than the code-quality review: does the code read like
Mercury — does it use the language's grain rather than fighting it?*

## Verdict: 7/10

The reference code usually reads like Mercury. Relations carry explicit modes and
determinisms; effects thread through `!IO`; maps and folds are functional; DCG notation is
used for grammars; concurrency uses channels, not shared mutation. The one systematic
departure — and it recurs across the parsing track — is **manufacturing `det` by accepting
or truncating invalid input**. That is legal Mercury but the wrong instinct to generalize,
and it is the single highest-value idiomatic fix.

## Where the code is strongly idiomatic

### Relations state their direction and cardinality

The best modules distinguish deterministic transformation, semidet validation, and nondet
generation instead of forcing everything into one shape:

- `data-structures/02-expr_eval.m:29-46`: total evaluation as a pure
  `func(env, expr) = maybe(int)`, with `maybe` reserved for genuine failure (unbound var,
  div-by-zero). `bind_maybe`/`map_maybe` express dependent failure propagation directly —
  this is good *functional* Mercury, not Prolog-with-types.
- `logic/02-nqueens.m:12-31`: search is `queens/2 is nondet`, conflict-checking is
  `safe/3 is semidet`. The accumulator and `Dist` document the geometry without disguising
  search as list-building.
- `data-structures/03-graph.m:27-47`: a `det` visited-set traversal *and* a `nondet`
  relational traversal under `loop_check`. Presenting both is specifically Mercury-shaped.
- `advanced/05-gen_parser.m:57,63`: the typeclass constraint sits on `satisfy` (which calls
  the method) but not on `many_p` (which only calls its argument). Precise constraint
  placement, not blanket decoration — a genuinely instructive detail.

### Effects and higher-order code

- `anagrams.m:18-32` and `histogram.m:13-24`: `list.foldl` with a map accumulator;
  `!Map`/`!.Map`/`!:Map` makes the update flow readable without pretending the map mutates.
- `concurrent/02-pipeline.m:62-70`: the idiomatic concurrency baseline — `main/2` stays
  `det`, and `promise_equivalent_solutions [!:IO]` explicitly fences the `cc_multi` from
  `thread.spawn`. The channel element type (`maybe(int)`) encodes the end-of-stream protocol.
- `concurrent/01-parallel_sort.m:64-67`: `&` used only between independent `det` recursive
  calls, rejoined by a sequential merge — the intended fork-join shape.
- `parsing/01-calculator.m:85-131`: DCG notation with accumulator nonterminals for
  left-associative operators — clearer and more idiomatic than threading token lists by hand.
- `advanced/06-plugins.m`: closure-valued record fields give open-world *extension* (new
  `mk_*` without touching the core). Clean — see the one nuance below.

## Patterns that teach the wrong default

### `det` is not a license to swallow invalid input

`det` means "exactly one result," not "malformed input becomes a plausible result." The
parsing track repeatedly conflates the two:

- `calculator.m:18-38`: `tokenize/2` is `det` because `token_list/3` returns `[]` on
  `one_token` failure and the remainder is discarded (`:22`). `"1 @ 2"` parses to `yes(1)`.
- `csv_reader.m:20-31,89-92`: a failed `row` is treated as EOF and the remainder ignored.
- `config_parser.m:34-52`: malformed nonblank lines are silently dropped.

The idiomatic interface makes the failure contract visible in the *type or determinism*:
`tokenize(string) = parse_result(list(token))`, or a `semidet` parser with a checked-empty
remainder. A total parser that returns a partial value should be named for it
(`parse_config_lenient`) and documented. This is the change that would most improve the
reference code as a model.

### Magic sentinels instead of algebraic "no candidate yet"

`memoized_search.m:46` uses `999999 - []` as a min-fold seed — an imperative sentinel that
silently misbehaves at the boundary. Pattern-match the first solution as the seed, or fold
to `maybe(pair(int, list(node)))`. (`sudoku.m`'s out-of-bounds `0`/`[]` returns are the
same instinct in indexing helpers.)

### Use `solutions/2` only when you need the whole set

`sudoku.m:146` collects every solution and uses the first; the idiomatic first-solution
form is committed choice (`( solve(Puzzle, S) -> ... ; ... )`). Contrast `nqueens.m:47`,
which uses `solutions/2` correctly *because* it displays the count. The two sitting side by
side in the same track is, frankly, a teaching opportunity — one could cross-reference them.

### Calling immutable threading "unique state"

`stats_pipeline.m:35-38` describes the count/sum/max triple as "the unique state of this
stage ... the same linearity that array_di/array_uo enforces." These are ordinary immutable
values passed to a tail call. The analogy to linear evolution is useful, but Mercury's
*uniqueness* (`di`/`uo`) is a mode-enforced property these values do not have. Keep the
analogy, drop the claim of enforcement. Relatedly, `stats_pipeline.m:4`'s `main/2 is
cc_multi` is the non-idiomatic counterpart to `pipeline.m`'s contained `det` main.

### The plugins/existential equivalence is slightly overstated

`plugins.m:12-15` says the closure-valued field gives "the same open-world property as
existential types." It gives open-world *extension*, but the interface is a single fixed
function — a constrained existential could expose a multi-method interface and let you add
methods later. The README (`:67-73`) actually makes this distinction well; the in-code
comment should match it rather than imply full equivalence.

## Naming and comments

General naming is good: `reachable_manual`, `first_empty`, `valid_so_far`, `count_words`,
`safe`. The improvements are to (a) the terse meta-interpreter constructors and helpers
(`a`/`n`/`f`/`v`/`c`, `rename_2`, `apply_env_f` — see code-quality review), and (b) the
`FIX:` comments in `calculator.m` that record a past compiler fight instead of the
invariant being maintained. Rewrite "FIX: multiple clauses → if-then-else" as "maximal-munch
lexing as a deterministic conditional chain." Reference source should explain the design,
not the diff.

## Standard to hold future reference solutions to

1. `det` only when every input has a meaningful result; use `semidet`/`maybe`/a result type
   for validation and parsing failure.
2. Let modes and determinism describe the real relation; don't weaken `main/2` to
   accommodate a call you can contain with `promise_equivalent_solutions [!:IO]`.
3. Prefer `maybe`, tagged results, and first-element folds to magic sentinels.
4. Put semantic preconditions (parser progress, index validity, channel shutdown ownership,
   collection ordering) in a comment next to the predicate that relies on them.
5. Preserve the existing strengths: `foldl`/`map` state threading, DCG grammar structure,
   explicit higher-order insts, precise typeclass-constraint placement, and `nondet`
   generators paired with `semidet` pruning.
