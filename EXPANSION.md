# Cinnabar — Expansion Roadmap

Comprehensive plan for building out Cinnabar into a full post-tutorial Mercury learning
repository. Three tiers:

- **Tier 1 (foundations)** — essentials for any real Mercury work
- **Tier 2 (intermediate)** — type system depth, mode system, determinism, parsing, tooling
- **Tier 3 (advanced)** — concurrency, FFI depth, solver types, RTTI

**Guiding principles:**
- All exercises use new programs. Where a concept appears in the Mercury tutorial, the
  README says so and cross-references the tutorial section — but the exercise uses a
  different problem domain.
- Koans contain a broken/incomplete `.m` file and a `solution/` subdirectory. The README
  describes the gap; the compiler is the teacher.
- Puzzles are open-ended: no single target concept, solutions provided.
- **Repetition must be engineered, not assumed.** Concepts appearing 1–3 times with
  incidental recurrence is not enough. Two mechanisms: (1) kata `start.m` skeletons with
  a `runtests` script so the edit→compile→green loop is friction-free; (2) bridge
  exercises that revisit a concept in a new context (extending working code rather than
  building from scratch). The bridge tier already exists for `maybe`, `higher-order`, and
  `DCGs`; expand it as new katas land.

---

## Target directory structure

```
cinnabar/
  README.md
  ROADMAP.md (this file)
  katas/
    foundations/          ← Tier 1: essentials
    type-system/          ← Tier 2: discriminated unions → type classes → existential
    mode-system/          ← Tier 2: insts → uniqueness → higher-order insts
    determinism/          ← Tier 2: six categories → committed choice → scope
    parsing/              ← Tier 2: DCGs and parsing_utils
    tooling/              ← Tier 2/3: grades, mdb, profiling, tabling
    concurrency/          ← Tier 3: parallel conjunction, thread module
    advanced/             ← Tier 3: FFI depth, solver types, RTTI
  koans/
    foundations/
    type-system/
    mode-system/
    determinism/
    parsing/
    tooling/
    concurrency/
    advanced/
  bridge/                 ← working code to extend (between katas and puzzles)
    01-maybe-extend/
    02-pipeline-extend/
    03-dcg-extend/
  puzzles/
    logic/
    data-structures/
    parsing/
    concurrent/
    advanced/
```

---

## Katas: foundations/ (Tier 1)

### Status of existing content

| Directory | Status | Notes |
|---|---|---|
| `00-reactivation/` | Revise READMEs | Add tutorial cross-references to exercises 01, 02, 03 |
| `01-modules/` | Revise | Add `import_module` vs `use_module` section and interface file explanation |
| `02-map/` | Rename → `05-map/` | Content unchanged |
| `03-set/` | Rename → `06-set/` | Content unchanged |

### New foundations katas

#### `02-maybe/`
**Build:** a small config-reader returning `maybe(string)` for optional fields. Chain
`maybe.map` and `maybe.bind`. Cover `yes(T)` / `no` constructors and the idiom of
threading optional values without explicit `if-then-else` on every call.

**Tutorial ref:** `maybe(T)` not in tutorial. No cross-reference needed.

#### `03-string/`
**Build:** a word-wrap formatter. Takes a string and column width, splits on
`string.words`, accumulates lines with a running width. Uses `string.length`,
`string.append`, `string.join_list`. Demonstrates the UTF-8 gotcha: `string.length`
returns code units, not codepoints — use `string.count_codepoints` for human-facing
counts.

**Tutorial ref:** basic `io.write_string` is in the tutorial. `string` module
manipulation is not.

#### `04-higher-order/`
**Build:** a pipeline of list transformations over a hardcoded dataset — `list.map`,
`list.filter`, `list.filter_map`, `list.foldl2` threading two accumulators. Then: store
a predicate in a variable, annotate the inst (`pred(in) is det`), call it with `call/1`.
Demonstrate that omitting the inst annotation causes a compile error.

**Tutorial ref:** tutorial may cover basic higher-order. Higher-order insts
(`pred(in) is det` in the variable's inst) are not covered.

#### `07-exceptions/`
**Build:** a file-line-counter. Opens a file with `io.open_input` (returns
`io.res(io.text_input_stream)`), pattern-matches on `ok(Stream)` vs `error(Msg)`, reads
lines until EOF, closes. Second section: throw a `software_error("...")` intentionally,
catch with `exception.catch_any`, print. Two exercises in one file or two separate
programs.

**Tutorial ref:** exception handling not in tutorial.

#### `08-built-in-types/`
**Build:** a set of short exercises demonstrating the non-obvious corners:
- Integer division: `//` vs `/` (type error); `rem` vs `mod` (sign difference on negatives)
- Float literals requiring a decimal point
- `io.format` poly-type tagging: `i(N)`, `s(Str)`, `f(F)`, `c(Ch)`
- `int.max_int`, `int.pow`, bitwise ops
- `char` vs `string` (single char is not a one-char string)

**Tutorial ref:** "Mercury tutorial §2-3 covers these types. This kata focuses on the
corners the tutorial does not dwell on."

#### `09-record-update/`
**Build:** a series of short exercises focused on field access and update syntax:
1. Define a `person` record with `name :: string`, `age :: int`, `score :: float`.
   Read fields with `^`: `Person^name`, `Person^age + 1`
2. Functional update with `:=`: `Person^age := Person^age + 1`
3. Chained updates and the "copy-on-modify" mental model — `Person0`, `Person`, `Person2`
   naming convention; why Mercury records are not objects
4. A common gotcha: `:=` inside a function vs. inside a predicate — the syntax is
   identical but the binding rules differ

This is implicit throughout the curriculum but never the main lesson anywhere.

**Tutorial ref:** field access syntax not covered.

#### `10-stdlib-collections/`
**Build:** a tour of the less-visited stdlib structures through small, connected exercises:
- `bag` — multiset; count word occurrences without a `map`; compare with `map`-based approach
- `digraph` — directed graph; represent a dependency tree; find a topological sort
  using `digraph.return_vertices_in_from_to_order`
- `bimap` — bidirectional map; build a two-way symbol table; look up in both directions
- `array` vs `version_array` — fill a 10×10 matrix both ways; explain why `array` requires
  unique modes and `version_array` allows sharing

**Tutorial ref:** stdlib collections not in tutorial beyond `list` and `map`.

#### `11-mode-inference/`
**Build:** three short programs demonstrating goal reordering:
1. `C = A + B, A = 1, B = 2` — write it "backwards" and confirm it still builds
2. A predicate with `(in, out)` and `(in, in)` mode declarations — verify both compile
3. Trigger a mode error by using a variable before it is bound; read the error carefully

**Tutorial ref:** tutorial covers basic modes. Goal reordering and multi-mode predicates
likely not covered.

### Revised foundations track order

```
00-reactivation/        (predict/verify pass — revise READMEs)
01-modules/             (revised: + import_module vs use_module, interface files)
02-maybe/               (NEW)
03-string/              (NEW)
04-higher-order/        (NEW)
05-map/                 (renamed from 02-map)
06-set/                 (renamed from 03-set)
07-exceptions/          (NEW)
08-built-in-types/      (NEW)
09-record-update/       (NEW — field access/update syntax)
10-stdlib-collections/  (NEW — bag, digraph, bimap, array vs version_array)
11-mode-inference/      (NEW)
```

### 00-reactivation/ tutorial cross-references to add

| Exercise | Tutorial section | Note to add |
|---|---|---|
| `01-hello-world` | Mercury Tutorial §1 | Same concepts; different program. Note di/uo vs. what the tutorial shows. |
| `02-fibonacci` | Mercury Tutorial §3-4 (predicates, determinism) | Same concepts; different program. Note if-then-else expression form. |
| `03-daytype` | Mercury Tutorial §2-3 (types, pattern matching) | Partial overlap; note multi-clause func specifics not in tutorial. |

Exercises 04–07 have no tutorial overlap; no changes needed.

### 01-modules/ additions

New section to add to the existing README:

**`import_module` vs `use_module`:** Using `import_module` in an interface section
silently makes the imported names transitively available to all clients of your module.
Use `use_module` in interface sections; reserve `import_module` for implementation
sections. This is one of the most commonly missed distinctions in real Mercury projects.

**Interface files (`.int`, `.int2`, `.int3`):** `mmc --make` generates these
automatically into the `Mercury/` directory. They are what allow the compiler to type-
and mode-check your module's callers without recompiling your module from scratch. Never
edit them by hand; add `Mercury/` to `.gitignore`.

---

## Katas: type-system/ (Tier 2)

#### `01-discriminated-unions/`
**Build:** a simple expression evaluator. Define
`expr ---> num(int) ; add(expr, expr) ; mul(expr, expr) ; neg(expr)`. Write
`eval(expr::in, int::out) is det`. Extend with `div(expr, expr)` that can fail on
division by zero — change to `semidet`. Demonstrates the general discriminated union
pattern beyond named-field records.

**Tutorial ref:** "Mercury tutorial §2 covers basic type declarations. This kata uses
a recursive discriminated union, which the tutorial does not cover."

#### `02-parametric-polymorphism/`
**Build:** a generic binary tree. `:- type tree(T) ---> leaf ; node(tree(T), T, tree(T))`.
Write `insert`, `member`, `to_sorted_list` — all polymorphic. Then write `tree_map`
applying a function to every value. Demonstrates user-defined parametric types.

**Tutorial ref:** tutorial covers `list(T)` as a built-in. Writing your own parametric
type is not covered.

#### `03-abstract-types/`
**Build:** an opaque `counter` type. Interface exports `counter`, `init`, `increment`,
`decrement`, `value` — no constructors. Implementation defines it as
`counter ---> counter(int)`. A second module tries to pattern-match on the constructor
directly — confirm the compile error. Demonstrates representation independence.

**Tutorial ref:** interface/implementation split likely in tutorial. Withholding
constructors to create abstract types is not.

#### `04-type-classes/`
**Build:** `:- typeclass printable(T) where [pred print_item(T::in, io::di, io::uo) is det]`.
Write instances for `int`, `string`, and a custom `point ---> point(float, float)`.
Write `print_list(list(T), io::di, io::uo) is det <= printable(T)`. Demonstrates
typeclass declaration, instance syntax, and constraint syntax. Note: no default method
implementations allowed — every instance must define every method.

**Tutorial ref:** type classes not in tutorial.

#### `05-typeclass-depth/`
**Build:** extend the `printable` typeclass from `04` with:
1. A superclass constraint — `printable` requires `comparable` (i.e., you can only print
   things you can also compare)
2. A multi-parameter typeclass: `convertible(From, To)` with `convert(From::in, To::out)`
   — demonstrates that Mercury typeclasses can range over multiple type variables
3. Functional dependencies: `serializable(T, Format)` with `| T -> Format` — one format
   per type, fixing the ambiguity that arises without FDs

Note: Mercury's typeclass system is structurally identical to Haskell 98 + FDs.
No default method implementations are allowed — every instance must define everything.

**Tutorial ref:** not in tutorial.

#### `06-existential-types/` (Tier 3)
**Build:** a heterogeneous list of `printable` values.
`:- type any_printable ---> some [T] (wrap(T) => printable(T))`.
Store an `int` and a `point` in the same list. Iterate and call `print_item` on each.
Demonstrates OOP-style dispatch without OOP.

**Tutorial ref:** existential types not in tutorial.

---

## Katas: mode-system/ (Tier 2)

#### `01-insts-and-modes/`
**Build:** three short programs with user-defined insts:
1. `bound_pos` inst for a die face — write `roll_die` with this inst on its output
2. A mode requiring `maybe(int)` to be `bound(yes(ground))` — passing `no` causes a mode error
3. A parametric inst: `list_of_ground(I)` matching `[] ; [I | list_of_ground(I)]`

**Tutorial ref:** basic `in`/`out` in tutorial. User-defined insts not covered.

#### `02-multi-mode/`
**Build:** `list_length/2` with two modes — `(in, out) is det` and `(out, in) is multi`.
Mode-specific clauses, `pragma promise_equivalent_clauses`. Then implement `my_append/3`
with three modes: `(in, in, out)`, `(out, in, in)`, `(in, out, in)`.

**Tutorial ref:** single-mode predicates in tutorial. Multi-mode with mode-specific
clauses not covered.

#### `03-uniqueness-deep/`
**Build:** unique-mode arrays. Create `array(int)`, set elements (requires
`array_di`/`array_uo`), attempt to branch on a unique array in a disjunction — read
the compile error. Use `version_array` as the alternative for shared access.
Demonstrates uniqueness loss and the practical workaround.

**Tutorial ref:** `di`/`uo` on `io.state` in tutorial. Array uniqueness and
`version_array` not covered.

#### `04-higher-order-insts/`
**Build:** a dispatch table — `map(string, pred(int::in, int::out) is det)` mapping
names to integer transforms. Look up by name, call via `call/2`. Demonstrate the compile
error when the map value type lacks inst annotation. Then attempt to store predicates of
different modes in a list — demonstrate why it fails and what existential types would fix.

**Tutorial ref:** not in tutorial.

#### `05-mode-specific-clauses/`
**Build:** `my_append/3` with three modes and `pragma promise_equivalent_clauses`.
Verify all three modes work and produce equivalent results.

**Tutorial ref:** not in tutorial.

---

## Katas: determinism/ (Tier 2)

#### `01-six-categories/`
**Build:** one predicate per determinism category:
- `det`: arithmetic expression evaluator
- `semidet`: safe list head
- `multi`: coin denomination combiner (2p+5p for N pence — at least one solution)
- `nondet`: factor finder
- `erroneous`: `abort(string::in) is erroneous :- throw(software_error(S))`
- `failure`: `always_fails is failure :- fail`

**Tutorial ref:** "Mercury tutorial §3 covers det/semidet/nondet basics. This kata
names and exercises all six categories explicitly, including `multi`, `erroneous`,
and `failure`."

#### `02-committed-choice/`
**Build:**
1. Generator predicate wrapped in `cc_nondet` and called from `det` context — only first
   solution used
2. `main/2` declared `cc_multi` — when and why
3. `promise_equivalent_solutions [X] (nondet_pred(X))` — casting to `det` by asserting
   solution equivalence

**Tutorial ref:** not in tutorial.

#### `03-scope-annotations/`
**Build:** a switch over a custom ADT with `require_complete_switch` — add a new
constructor to the ADT and watch the annotation catch the missing case before any
runtime test. Also: `require_det` on a sub-goal inside a `semidet` predicate.

**Tutorial ref:** not in tutorial.

---

## Katas: parsing/ (Tier 2)

#### `01-dcg-basics/`
**Build:** a simple arithmetic expression parser using DCGs. Grammar:
`expr --> term, [+], expr | term`, `term --> [int(N)]`. Input is `list(token)`, output
is an `expr` ADT. Demonstrates `-->` syntax, alternatives, terminal symbols.

**Tutorial ref:** DCGs not in tutorial.

#### `02-dcg-goals/`
**Build:** extend the expression parser with `{Goal}` semantic actions. Use
`{string.to_int(Str, N)}` inline to convert scanned tokens. Demonstrates why `{}`
escaping is necessary and what happens without it.

**Tutorial ref:** not in tutorial.

#### `03-parsing-utils/`
**Build:** a config file parser using `parsing_utils`. Parse `key = value` lines from
a string. Use `parsing_utils.whitespace`, `parsing_utils.next_char`,
`parsing_utils.literal`. Return `map(string, string)`. Real-world parsing without a
hand-written lexer.

**Tutorial ref:** not in tutorial.

---

## Katas: tooling/ (Tier 2/3)

#### `01-grades/`
**No code.** Reference guide covering:
- Grade anatomy: base (`asm_fast`, `hlc`, `java`, `csharp`) + modifiers
  (`.gc`, `.debug`, `.par`, `.prof`, `.tr`, `.mm`, `.stseg`)
- Feature/grade dependency table
- Why grade mismatch at link time causes confusing errors
- When to use `hlc.gc.pregen` vs `asm_fast.par.gc`
- How to check which grades are available: `mmc --grade` inspection

#### `02-trace-goals/`
**Build:** three short programs demonstrating `trace` goals:
1. `trace [io(!IO)] ( io.write_string("reached here\n", !IO) )` — conditional debug
   output that compiles away in non-debug grades; demonstrates that `trace` is the
   Mercury-idiomatic alternative to `printf` debugging
2. A `trace` goal that fires only when a variable exceeds a threshold — shows runtime
   conditions inside `trace`
3. `trace [compile_time(flag("debug_mode"))]` — a compile-time flag that gates tracing
   without affecting non-debug builds

Note: `trace` goals are pure-safe because they do not affect the computation, only
observation. The compiler proves this.

**Tutorial ref:** not in tutorial.

#### `03-debugging-mdb/`
**Build:** a deliberately buggy program (off-by-one in list indexing). Compile with
`--grade asm_fast.gc.debug`. Run under `mdb`, find the bug using 4-port tracing, then
find it again using declarative debugging mode. Requires a `.debug`-grade Mercury install.

#### `04-profiling/`
**Build:** naive vs memoized Fibonacci. Compile with `.prof` grade, profile, identify
the hotspot. Then compile with `.profdeep` and compare attribution. Demonstrates why
deep profiling gives more accurate results than flat gprof.

#### `05-tabling/`
**Build:** exponential Fibonacci → add `pragma memo(fib/2)` → measure speedup. Then
`pragma loop_check` on a mutually recursive pair to demonstrate cycle detection.
Note: requires C grade (not Java).

**Tutorial ref:** not in tutorial.

---

## Katas: concurrency/ (Tier 3)

#### `01-parallel-conjunction/`
**Build:** two `det` computations (summing two large ranges) combined with `&`. Compile
with `.par` grade, compare timing vs `,`. Demonstrates that both conjuncts must be `det`
or `cc_multi`; demonstrates that `semidet` in `&` is a compile error.

#### `02-threads/`
**Build:** producer-consumer over `thread.channel`. One thread produces integers 1..N,
another consumes and accumulates. Uses `thread.spawn`, `channel.put`, `channel.take`.
Demonstrates that all thread communication goes through `!IO`.

---

## Katas: advanced/ (Tier 3)

#### `01-ffi-depth/`
**Build:** bind a C library function (`gettimeofday`). Use all four FFI pragma types:
`foreign_decl` for the C header, `foreign_type` to map the C struct,
`foreign_proc` to call it, `foreign_export` to make a Mercury predicate callable from C.
Covers FFI attributes: `will_not_call_mercury`, `thread_safe`, `tabled_for_io`.

#### `02-solver-types/`
**Reference kata — no working build.** Explains solver types and the `any` inst
conceptually. Shows `:- solver type` declaration and `where` clause. Documents what
`.tr` (trailing) grade provides. Pointer to external CLP resources. Notes that a
working solver requires an external CLP engine not bundled with Mercury.

#### `03-global-state/`
**Build:** two programs demonstrating Mercury's two approaches to global mutable state:

1. **`:- mutable`** — declare a module-level mutable variable with `impure`/`semipure`
   pragmas. Increment a global counter across calls. Show why mutable preds require
   `promise_pure` or explicit `impure`/`semipure` declarations — Mercury's purity system
   tracks side-effects at the type level.

2. **`store`** — a typed heap-allocated cell passed through `!IO`. Create a `store`,
   allocate a `store_mutvar`, read and write it. Compare with `:- mutable`: `store` is
   pure (threaded through a state token); `:- mutable` is impure (truly global). The
   practical rule: prefer `store` or `io.mutvar` in concurrent code; reserve `:- mutable`
   for module-level configuration initialized once at startup.

**Tutorial ref:** not in tutorial.

#### `04-rtti/`
**Build:** a generic pretty-printer using `deconstruct.deconstruct/5` to recursively
decompose any Mercury value into its functor and arguments, printing as an indented
tree. Uses `type_of`, `deconstruct`, `construct` modules. Notes when RTTI is appropriate
(debugging, serialization) and when reaching for it signals a design problem.

---

## Koans index

Each koan: one `.m` file with a specific gap or bug, plus `solution/` subdirectory.

| Koan | Broken concept | What the compiler error teaches |
|---|---|---|
| `foundations/01-maybe` | Raw `if-then-else` on `yes`/`no` instead of `maybe.map` | Recognizing the maybe-threading pattern |
| `foundations/02-string` | `string.length` used as codepoint count on UTF-8 | Code-unit vs codepoint distinction |
| `foundations/03-higher-order` | `pred(int, int)` type without inst annotation — `call` rejected | Higher-order inst annotation is mandatory |
| `foundations/04-modules` | `import_module` in interface section | Transitive export; use `use_module` in interfaces |
| `foundations/05-exceptions` | `io.open_input` result not pattern-matched — `ok(Stream)` blindly extracted | Proper `io.res` handling |
| `foundations/06-file-io` | File handle not closed on error path | Resource cleanup discipline |
| `foundations/07-built-in-types` | Integer division with `/` instead of `//` | Type error on `/` applied to `int` |
| `type-system/01-adt` | Non-exhaustive switch on discriminated union | Total switches as safety net |
| `type-system/02-typeclass` | Instance declared for `list(int)` (concrete instantiation — forbidden) | Instance parameter restriction |
| `type-system/03-abstract` | Client module pattern-matches on abstract type constructor | Encapsulation enforcement |
| `type-system/04-parametric` | Type variable in body but not head — scoping error | Type variable quantification |
| `mode-system/01-inst` | Unique value passed to two branches of disjunction | Uniqueness can only be consumed once |
| `mode-system/02-inference` | Variable used before bound — reordering cannot save it | When mode inference gives up |
| `mode-system/03-higher-order-inst` | Higher-order pred stored without inst, then called | Inst annotation required to call |
| `determinism/01-det-mismatch` | `det` predicate with if-then-else missing the else | Determinism checker catches missing cases |
| `determinism/02-nondet-in-det` | `nondet` predicate called from `det` context without `solutions` | Determinism containment rules |
| `determinism/03-committed-choice` | `cc_nondet` called from `semidet` context | Committed choice propagation |
| `parsing/01-dcg-goals` | DCG rule uses `(Goal)` instead of `{Goal}` for embedded Mercury | `{}` escaping is mandatory |
| `parsing/02-dcg-mixed` | DCG and non-DCG predicate mixed — extra hidden args cause type error | DCG hidden argument confusion |
| `tooling/01-grade` | `.debug` grade not used but `mdb` invoked | Grade/feature dependency |
| `concurrency/01-parallel` | `semidet` predicate in parallel conjunction | `&` requires `det` or `cc_multi` |
| `advanced/01-ffi` | `foreign_proc` missing `will_not_call_mercury` — unnecessary mutex | FFI attribute impact on performance |

---

## Puzzles index

### logic/

#### `01-sudoku`
Solve a 9×9 Sudoku using nondet generate-and-test with set-based row/column/box
constraints. Primary skills: `nondet`, `solutions/2`, `set`. What makes it interesting:
early constraint checking dramatically prunes the search — the puzzle teaches that when
you apply constraints matters, not just that you apply them.

#### `02-n-queens`
Place N queens on an N×N board with no conflicts. Primary skills: `nondet`, `solutions/2`,
arithmetic constraints. Teaches: building up partial solutions left-to-right prunes
exponentially vs. generating all placements and filtering.

#### `03-crypto-arithmetic`
SEND + MORE = MONEY style constraint problem. Primary skills: `nondet`, `aggregate/4`
vs `solutions/2` comparison, arithmetic. Introduces `aggregate` as more efficient for
large solution sets.

### data-structures/

#### `01-anagram-finder`
Given a word list, group words that are anagrams of each other. Primary skills: `map`,
`string`, `list.sort`. Approach: sort each word's letters → use sorted form as map key
→ group values.

#### `02-expression-evaluator`
Recursive interpreter over an `expr` ADT with variables. Input: expression + variable
binding map. Output: `maybe(int)` (fails on unbound variable or division by zero).
Primary skills: discriminated unions, `map`, `maybe`, recursion. Foreshadows the
conditions-as-data / recursive-interpreter shape of a QBN engine.

#### `03-graph-reachability`
Find all nodes reachable from a given node in a directed graph. Primary skills: `set`,
recursion, tabling (`pragma memo` to handle cycles). Teaches why tabling is the right
tool for recursive queries over cyclic graphs.

#### `04-frequency-histogram`
Read text from stdin, count word frequencies, display a sorted ASCII histogram with
relative bar lengths. Primary skills: `map`, `list`, `string`, `io`. Extends the
02-map kata into a complete program.

### parsing/

#### `01-calculator`
Full four-operation calculator: lexer → DCG parser → evaluator. Input: string like
`"3 + 4 * (2 - 1)"`. Output: `int`. Handles operator precedence via grammar structure.
Primary skills: DCGs, ADTs, `maybe` for parse errors, recursion.

#### `02-csv-reader`
Parse a CSV file with quoted fields (fields may contain commas and newlines if quoted).
Primary skills: DCGs, `string`, `io.res`, `list`. Non-trivial because quoted fields
require looking ahead for closing quotes.

#### `03-config-parser`
Structured config file (`key = value` with section headers `[section]`) → typed record
using abstract types. Primary skills: `parsing_utils`, `map`, `maybe`, abstract types.
The output type hides its `map` implementation behind an abstract `config` type.

### concurrent/

#### `01-parallel-sort`
Mergesort with `&` at the recursive split point. Compare timing vs sequential for
various list sizes. Primary skills: parallel conjunction, `list`, divide-and-conquer.
Shows that parallel overhead matters at small sizes.

#### `02-pipeline`
Three-stage pipeline: reader thread → transformer thread → writer thread, connected
by `thread.channel` pairs. Primary skills: `thread.spawn`, `thread.channel`, `!IO`.
Demonstrates that channels serialize access and that the `!IO` state sequences thread
operations correctly.

### advanced/

#### `01-generic-printer`
Print any Mercury value as an indented tree using RTTI. Value → functor name + arity
+ recursive argument list, displayed with indentation. Primary skills: `deconstruct`,
`type_of`, `univ`, recursion.

#### `02-memoized-search`
Shortest path over a weighted directed graph. Naive recursive approach loops on cycles;
`pragma memo` on the path predicate breaks cycles and caches intermediate results.
Compare performance on a large graph. Primary skills: tabling, `nondet`, `solutions/2`,
arithmetic.

---

## Tutorial cross-reference table

| Cinnabar item | Exercises same Mercury concepts as | Tutorial section |
|---|---|---|
| `katas/foundations/00-reactivation/01-hello-world` | Module skeleton, `!IO` threading | Mercury Tutorial §1 |
| `katas/foundations/00-reactivation/02-fibonacci` | Recursive `det` predicates, if-then-else expression | Mercury Tutorial §3-4 |
| `katas/foundations/00-reactivation/03-daytype` | Pattern matching, multi-clause funcs | Mercury Tutorial §2-3 |
| `katas/foundations/01-modules` | Module system basics | Mercury Tutorial §5 |
| `katas/type-system/01-discriminated-unions` | Basic type declarations | Mercury Tutorial §2 |
| `katas/mode-system/02-multi-mode` | Basic mode annotations | Mercury Tutorial §4 |
| `katas/determinism/01-six-categories` | det/semidet/nondet basics | Mercury Tutorial §3 |

All other Cinnabar items have no tutorial equivalent.

---

## Execution order

Execute in this sequence to maintain internal coherence:

1. Rename `02-map` → `05-map` and `03-set` → `06-set`
2. Revise `00-reactivation/` READMEs (add tutorial cross-refs)
3. Revise `01-modules/` README (add import/use section + interface files)
4. Revise `katas/foundations/README.md` (updated track order)
5. Create new foundations katas: 02-maybe, 03-string, 04-higher-order, 07-exceptions,
   08-built-in-types, 09-record-update, 10-stdlib-collections, 11-mode-inference
6. Create `katas/type-system/` track (01 through 06, including 05-typeclass-depth)
7. Create `katas/mode-system/` track (01 through 05)
8. Create `katas/determinism/` track (01 through 03)
9. Create `katas/parsing/` track (01 through 03)
10. Create `katas/tooling/` track (01 through 05, including 02-trace-goals)
11. Create `katas/concurrency/` track (01 through 02)
12. Create `katas/advanced/` track (01 through 04, including 03-global-state)
13. Add `start.m` skeletons + `runtests` scripts to all katas
14. Create all koans (22 total, with `.m` files and `solution/` dirs)
15. Create all puzzles (14 total, with problem statements and solutions)
16. Add bridge exercises for new kata concepts as they land

Estimated new files: ~140 (directories + READMEs + .m files + start.m skeletons)

---

## Depth Targets

### Philosophy

The breadth of the current curriculum is a genuine strength. But breadth without depth
produces a learner who can *recognise* every Mercury feature and can't *use* most of
them fluently.

Mercury has a small number of features that are genuinely unlike what any other language
teaches. These are the features where:

1. Shallow exposure produces the most confusion in real code
2. Learning resources beyond the reference manual are almost nonexistent
3. Surface-level competence and genuine mastery diverge the most sharply

Those features are **determinism**, the **mode and inst system**, and the **type system**
(particularly typeclasses and existential types). Higher-order programming, DCGs, and
concurrency are also deep enough to reward multi-level treatment — but they have more
analogues in other languages, so the depth gap is smaller.

**Depth principle:** Go deep where Mercury is unique. A Haskell programmer who learns
Mercury already understands typeclasses at a reasonable level. They do not understand
the determinism system. A Prolog programmer understands backtracking. They do not
understand uniqueness or committed choice. Invest depth proportional to the learning
resource gap, not proportional to how interesting the feature is in the abstract.

**Depth format:** Each pillar concept needs a progression from *shallow* (the kata
introduces it) through *intermediate* (exercises that break the simple mental model) to
*deep* (exercises that require genuine internalisation — where you can no longer succeed
by pattern-matching on examples you've seen). The bridge format is the right delivery
mechanism for intermediate and deep work: give the learner a working program and ask
them to extend it into territory the scaffold didn't anticipate.

**Mastery test:** Each pillar ends with a description of a program the learner should be
able to write confidently from scratch, without help. If they can't write it, they haven't
reached mastery — and the exercises haven't worked.

---

### Pillar 1: Determinism

#### What shallow exposure gives you

You can name the six categories. You can annotate a simple predicate correctly. You know
that `nondet` predicates need `solutions/2` to be used from a `det` context. You can
follow an example of `cc_nondet`.

#### What deep mastery looks like

You can reason about determinism in deeply nested code without counting it out. You
immediately see the determinism consequence of adding a disjunction or a negation. You
know exactly when `promise_equivalent_solutions` is valid and when it is a lie. You can
read any determinism error message, identify the root cause, and choose between the three
or four possible fixes — not by trying things but by understanding which structural
property is at issue. You never accidentally write `multi` when you meant `nondet` or
`cc_nondet` when you meant `cc_multi`.

#### Depth sequence

**Level 1 — Introduction (existing)**
- `katas/determinism/01-six-categories/` — one predicate per category

**Level 2 — Determinism in context**
- `katas/determinism/04-determinism-in-disjunctions/` — what happens when the two
  branches of a disjunction have different determinisms. Rules: `det ; det → det`,
  `det ; semidet → det`, `semidet ; semidet → semidet`, `det ; nondet → multi`,
  `semidet ; nondet → nondet`. Build exercises that hit each combination. Observe that
  the compiler uses the *least upper bound* in the determinism lattice.
  Introduce the lattice explicitly: `failure < semidet < det`; `failure < nondet < multi`;
  `semidet` and `nondet` are incomparable; `cc_nondet < cc_multi` sits between the det
  and nondet columns.

- `katas/determinism/05-determinism-and-negation/` — `\+` is always `semidet` regardless
  of the argument's determinism. `not(nondet_pred)` succeeds if the pred fails — but
  you lose the solutions. Why negation must be semidet: any solution Mercury commits to
  inside `\+` is discarded; the outer goal either succeeds (pred failed) or fails (pred
  succeeded). Show the classic pitfall: trying to use `\+` as a filter inside a
  `nondet` predicate, then wondering why solutions are missing.

**Level 3 — Committed choice**
- `katas/determinism/02-committed-choice/` (existing, expand) — deep dive:
  - `cc_nondet` in an if-then-else *condition* produces `semidet` (commits to one branch
    of the condition — but the overall if-then-else still might not find a solution)
  - `cc_multi` in an if-then-else *condition* produces `det` (always finds one, commits)
  - Exactly when does passing a `cc_nondet` pred to `solutions/2` make sense vs. when is
    it a logic error?
  - `promise_equivalent_solutions` correctness criterion: you are asserting that all
    solutions produce the same observable effect. The compiler cannot verify this. Show
    an example where the assertion is false (produces a different answer depending on
    which solution is chosen) — observe that the program is now incorrect but the
    compiler is silent. Mercury does not guard you from a false promise.

**Level 4 — Inference and annotation**
- `katas/determinism/06-inference-without-annotations/` — write a set of predicates with
  no determinism annotations. Run `mmc --infer-all`. Read the inferred annotations.
  Compare against what you expected. Common surprises:
  - A multi-clause predicate with non-overlapping guards is still inferred `nondet`
    unless the compiler can prove exhaustiveness and mutual exclusion (it usually cannot
    for arithmetic guards)
  - A predicate whose last clause is `fail` may be inferred `failure`
  - A `det` predicate calling a `cc_multi` predicate is inferred `cc_multi`, not `det`
  Exercises: write predicates, predict the inferred determinism, run mmc, explain
  discrepancies.

**Level 5 — Determinism and higher-order**
- `katas/determinism/07-higher-order-determinism/` — the determinism of a higher-order
  call is determined by the *inst* of the passed predicate, not by the call site. A
  predicate declared `pred(in) is det` passed to a caller cannot produce a `multi` result
  from that call. But what if the inst says `pred(in) is nondet`? What if the inst is
  missing and the compiler infers `ground`? What does `ground` mean for a predicate
  inst — and why does the compiler reject calling a `ground`-inst predicate at all?
  Exercises:
  - A higher-order map where the passed function is `det` — result is `det`
  - The same map where the passed function is `semidet` — result is `semidet` (may not
    produce an output for every input)
  - The same map where the passed function is `nondet` — result is... what? What does it
    mean to map a `nondet` function over a list?
  - A higher-order fold where the accumulator-update predicate is `cc_multi` — the fold
    can commit to one intermediate state at each step

**Level 6 — I/O and determinism**
- Mini-kata (could be a section of 01-six-categories): why everything that does I/O must
  be `det` or `cc_multi` in Mercury (not `semidet`). Attempting to write a `semidet`
  predicate that does I/O produces the error "predicate has determinism `semidet` but
  it has a side effect." The rule: `io.state` is unique; a unique value cannot be
  consumed in a branch that might not succeed. Mercury enforces this structurally.
  Show the workaround: if you want conditional I/O, use `det` with an
  if-then-else, not `semidet`.

**Level 7 — Systematic error reading**
- `koans/determinism/04-determinism-errors/` — a koan set specifically for recognising
  and diagnosing determinism errors. Broken files for each major error class:
  - "predicate X has determinism `multi` but must be `det`" — cause: multiple-clause
    predicate with non-exclusive guards
  - "if-then-else condition has determinism `nondet`" — cause: using a nondet predicate
    as an if-then-else condition
  - "predicate X has determinism `semidet` but has I/O" — cause: semidet predicate does
    I/O
  - "cannot use `&` with a `semidet` goal" — cause: parallel conjunction requires `det`
  - "warning: determinism `cc_multi` but declared `det`" — cause: calling a `cc_multi`
    predicate in a `det` context without `promise_equivalent_solutions`
  Solution READMEs explain the fix and the underlying rule.

#### Bridge ideas

- **Determinism Ratchet** (`bridge/04-determinism-ratchet/`): Start with a working
  `nondet` search predicate that finds all valid assignments. Task 1: wrap it to find
  only the first solution, returning `maybe(assignment)` — requires `cc_nondet` and
  `promise_equivalent_solutions`. Task 2: parallelize the search — each branch of a
  disjunction runs as a parallel conjunct; this requires the branches to be `det` or
  `cc_multi`. Show what must change and why. Task 3: add an early-exit condition
  (stop if a solution satisfies a secondary criterion) — show how committed choice
  propagates through the refactoring.

#### Mastery checkpoint

Given this error message:

```
foo.m:23: in `foo/2':
  determinism error: `foo/2' has determinism `multi' but it must have
  determinism `det'.
```

Without running the compiler again, identify: (a) what structural property of `foo/2`
causes `multi` to be inferred, (b) all the valid ways to fix it, (c) which fix is
correct for the intended semantics. Then write from scratch a predicate that: generates
integers from 1 to N nondeterministically, filters those satisfying two independent
conditions, commits to the first that satisfies both, returns `maybe(int)`, and is
callable from `det` main — using the minimum number of `promise_*` annotations.

---

### Pillar 2: Mode System

#### What shallow exposure gives you

You can use `in`/`out`/`di`/`uo`. You know the inst annotation syntax for higher-order
arguments. You know that `array` requires unique modes and `version_array` does not.

#### What deep mastery looks like

You can design a user-defined inst for a non-trivial data structure and write predicates
against it. You can read any mode error — including the notoriously opaque uniqueness
errors — and identify the exact cause. You understand inst subtyping and can predict
whether a given inst is a subtype of another. You can write a multi-mode predicate with
mode-specific clause bodies, and you know when `pragma promise_equivalent_clauses` is
valid. You understand what `any` means and when partial instantiation is needed.

#### Depth sequence

**Level 1 — Introduction (existing)**
- `katas/mode-system/01-insts-and-modes/` — basic user-defined insts, mode declarations

**Level 2 — The inst hierarchy**
- `katas/mode-system/06-inst-hierarchy/` — a structured tour of the inst lattice:
  - `free` — completely uninstantiated; can be unified with anything
  - `bound(f(I1, I2, ...))` — bound to a specific functor with sub-insts
  - `ground` — fully instantiated; equivalent to `bound(...)` with all sub-insts `ground`
  - `any` — may be free or bound (appears in solver type contexts)
  - `clobbered` — value has been consumed (unique-mode unique values become clobbered)
  - `unique` — the only live reference to this value; permits destructive update
  - `mostly_unique` — unique except possibly in a committed-choice context
  Exercises: predict the inst of a variable after various operations. Show why
  `ground` is a subtype of `any` but `unique` is not a subtype of `ground` (they
  describe different properties: groundness vs. aliasing).

**Level 3 — Uniqueness in depth**
- `katas/mode-system/03-uniqueness-deep/` (existing, expand significantly):
  - The aliasing problem: two variables pointing to the same value cannot both be
    `unique`. Mercury tracks this statically. Show the canonical failure: passing a
    `unique` array to both branches of an if-then-else.
  - `mostly_unique`: a weaker uniqueness guarantee that says "unique except possibly in a
    committed-choice context." This is what array operations produce when the context is
    `cc_multi`.
  - The `copy/2` workaround: explicitly copying a unique value to get two references.
    Cost: O(size). When it's unavoidable.
  - Uniqueness and higher-order: if you pass a `unique` value to a `pred(di, uo)`, the
    caller loses access. Show the error and the fix.
  - `version_array` as the engineering answer: same API as `array` but persistent — reads
    return the previous version intact. Build a persistent stack on top of `version_array`
    to show the pattern.

**Level 4 — Multi-mode predicates**
- `katas/mode-system/02-multi-mode/` (existing, expand):
  - Write `my_append/3` with modes `(in, in, out) is det`, `(out, in, in) is semidet`,
    `(in, out, in) is semidet`. The clauses must be different for forward vs. reverse
    modes. Add `pragma promise_equivalent_clauses` and explain what you are asserting:
    that all three mode implementations give the same logical relationship, even though
    the implementations diverge.
  - Show a case where `promise_equivalent_clauses` would be false: two mode-specific
    implementations that compute different things. Mercury cannot detect this; the
    program is incorrect.
  - Write `list_to_from/2` with `(in, out) is det` (convert list to a difference list)
    and `(out, in) is det` (flatten a difference list). Same pragma.

**Level 5 — Mode-specific clause selection**
- `katas/mode-system/07-clause-selection/` — how Mercury selects which clause to execute
  at runtime. Mercury resolves modes at compile time; the selected clause is determined
  by the calling mode, not by runtime pattern matching. Exercises:
  - Write a predicate with two clauses and two modes. Add debugging output to each
    clause. Confirm the right clause fires for each mode.
  - Show the error when clause selection is ambiguous (two clauses could both fire for
    the same mode).
  - Show the error when no clause covers a declared mode.

**Level 6 — Higher-order inst polymorphism**
- `katas/mode-system/04-higher-order-insts/` (existing, expand):
  - Mercury does not have true inst polymorphism (a single predicate that works for
    `pred(in) is det` and `pred(in) is semidet`). The workaround: declare separate
    versions or use `cc_multi`/`nondet` as the "weakest" inst and wrap.
  - Build a dispatch table: `map(string, pred(int::in, io::di, io::uo) is det)`.
    Inserting a `semidet` predicate into this table requires wrapping. Show the wrapper.
  - The `ground` inst for a predicate: means the predicate exists but its mode is
    unknown. Calling a `ground`-inst predicate is a mode error. This is the error that
    appears when you forget the inst annotation entirely.

**Level 7 — Reading mode errors**
- `koans/mode-system/05-mode-errors/` — a koan set for the most common mode error
  classes. Each broken file has exactly one mode error; the solution README explains:
  - "variable X has inst `free` but the call requires `ground`" — variable used before
    being bound; goal ordering won't help because the binding is inside a `semidet` branch
  - "variable X has inst `ground` but the call requires `unique`" — passing a possibly-
    shared value to a unique-consuming predicate
  - "variable X has inst `unique` but the call requires `ground`" — consuming a unique
    value in a context that doesn't thread uniqueness (rare but confusing)
  - "predicate X has mode `(in, out)` but the call has argument with inst `free`" —
    calling a forward-only predicate in reverse
  - Higher-order: "type error: expected `pred(int::in) is det` but got
    `pred(int::in) is nondet`" — inst mismatch on higher-order argument

#### Bridge ideas

- **Mode Reversal** (`bridge/05-mode-reversal/`): Start with a `string_to_int/2`
  predicate with mode `(in, out) is semidet`. Task 1: add the reverse mode
  `(out, in) is det` — implement it, add `pragma promise_equivalent_clauses`, verify
  both modes work. Task 2: add a third mode `(out, out) is nondet` that generates
  all valid pairs — observe that `promise_equivalent_clauses` is now incorrect (the
  third mode is not equivalent to the other two), understand what the pragma actually
  promises and why you shouldn't add the third mode to the same predicate. Task 3:
  add uniqueness — produce an `array(int)` from the conversion; thread the unique
  array through a fold using the reverse mode.

#### Mastery checkpoint

Design and implement a `sparse_array(T)` type backed by `map(int, T)`. Provide:
- `init(sparse_array(T)::uo) is det`
- `set(int::in, T::in, sparse_array(T)::di, sparse_array(T)::uo) is det`
- `lookup(int::in, T::out, sparse_array(T)::in) is semidet`
- `to_assoc_list(sparse_array(T)::in, assoc_list(int, T)::out) is det`

Declare the appropriate user-defined inst for `sparse_array`. Explain why `di`/`uo` is
correct here even though there's no destructive update happening. Write a short test
that threads a `sparse_array` through several `set` operations, then reads it back.

---

### Pillar 3: Higher-Order Programming

#### What shallow exposure gives you

You can pass a named predicate or lambda to `list.map`, `list.filter`, `list.foldl`. You
know the inst annotation syntax `pred(in, out) is det`. You can store a predicate in a
variable if you annotate the inst correctly.

#### What deep mastery looks like

You think in combinators. When you need to parameterize a data structure traversal, your
first instinct is a higher-order predicate, not a typeclass. You know the performance
characteristics of higher-order dispatch. You can build complex pipelines by composing
small predicates, and you can factor out shared structure into combinators without losing
the ability to reason about determinism or modes. You understand closure capture in
Mercury lambdas and know what variables are captured and how.

#### Depth sequence

**Level 1 — Introduction (existing)**
- `katas/foundations/04-higher-order/` — map, filter, foldl2, inst annotation

**Level 2 — Closure capture and lambda design**
- `katas/foundations/12-lambda-design/` (new):
  - What variables are captured in a Mercury lambda: all free variables in the lambda
    body. The capture is by value (Mercury's copying semantics), not by reference.
  - Show the implication for `!IO`: a lambda that does I/O must have `!IO` in its
    argument list — it cannot "capture" `!IO` from the enclosing scope because the I/O
    state is linear. This is one of the most commonly confusing points for newcomers.
  - Partial application via lambda: there is no currying syntax in Mercury. `add(1)` is
    not a valid expression. The idiomatic partial application is
    `(func(X) = add(1, X))` or `(pred(X::in, Y::out) is det :- Y = add(1, X))`.
  - Write a predicate that builds a list of "specialized" predicates, each capturing a
    different integer from a range. Call each one. Show that each captures independently.

**Level 3 — Combinator design**
- `katas/foundations/13-combinators/` (new):
  - `compose`: `compose(F, G, X) :- F(X, Y), G(Y, Z)` — or the function form.
    Show why this is trivially writable in Mercury but the inst annotation makes it
    more verbose than in Haskell.
  - `until`: apply a predicate repeatedly until a condition holds.
  - `while`: apply a predicate while a condition holds.
  - `map2`: map a predicate over two lists simultaneously, failing if they're different
    lengths.
  - `fold_map`: combine a fold and a map — accumulate a value while transforming a list.
  - Show why these are often not in Mercury's stdlib: the inst annotation is
    specific to the determinism of the passed predicate, which means you'd need a
    separate `compose_det`, `compose_semidet`, `compose_nondet` — making the stdlib
    cluttered. When to build a combinator vs. just write the loop inline.

**Level 4 — Higher-order and determinism (see also Pillar 1 Level 5)**
- The interaction between higher-order predicates and the determinism system is deep
  enough to warrant its own kata beyond the determinism pillar.
  `katas/foundations/14-higher-order-determinism/` (new):
  - A `map_semidet` that maps a `semidet` predicate over a list, collecting only the
    outputs where the predicate succeeds (this is essentially `list.filter_map`)
  - A `map_nondet` that maps a `nondet` predicate over a list, generating all
    combinations — this is effectively a list comprehension / do-notation
  - A `first_success(list(pred(T::out) is semidet), T::out) is semidet` — try each
    predicate in sequence; return the first that succeeds
  - A `any_of(list(pred is semidet)) is semidet` — true if any predicate in the list
    succeeds; show why naively calling each is potentially inefficient (no short-circuit
    at the higher-order level) and how to fix it

**Level 5 — Dispatch tables and strategy objects**
- `katas/mode-system/04-higher-order-insts/` (existing) covers part of this.
  Extend into `katas/advanced/05-strategy-objects/` (new):
  - A "rendering strategy" type: a record containing several `func` and `pred` values
    with explicit inst annotations — essentially a vtable. Implement two concrete
    strategies (HTML renderer, plain-text renderer). Switch between them at runtime by
    passing different records.
  - Compare to the typeclass approach (Pillar 5). Show when the record-of-functions
    approach is better (single instance needed at runtime, strategy changes during
    execution) and when typeclasses are better (all instances known at compile time,
    constraint propagation desired).
  - Show the limitation: Mercury cannot abstract over the inst of the stored predicates
    the way Haskell can abstract over type class dictionaries. The inst must be concrete.

#### Bridge ideas

- **Pipeline Parameterization** (`bridge/06-pipeline-parameterization/`): Start with
  the concrete `pipeline.m` bridge. Task 1: parameterize the filter step — instead of
  hardcoding `high_stock`, accept a `pred(item::in) is semidet`. Task 2: parameterize
  the transform step — accept a `func(item) = float`. Task 3: make the entire pipeline
  a first-class value: a record `pipeline(filter_pred, transform_func)` where the
  fields carry their inst annotations. Task 4: build two pipelines (one for revenue,
  one for weight) and fold over both using `list.foldl` — the pipeline record becomes
  the accumulator seed.

#### Mastery checkpoint

Implement a small event system:
```mercury
:- type handler(E) == pred(E::in, io::di, io::uo) is det.
:- type event_bus(E) ---> event_bus(handlers :: list(handler(E))).
```
with `subscribe`, `publish`, and `publish_all` operations. Then build a specific
instance: an `event_bus(log_event)` where `log_event ---> info(string) ; warning(string)
; error(string)`. Register three handlers (one writes to stdout, one writes to a file,
one counts errors into a mutvar). Publish a sequence of events. Verify all handlers
fire for each event.

---

### Pillar 4: DCGs and Parsing

#### What shallow exposure gives you

You can write a simple DCG grammar. You know `{Goal}` escaping. You can call a DCG
rule directly without `phrase/2`.

#### What deep mastery looks like

You can design a complete parser for a non-trivial language, handling precedence,
associativity, whitespace, and useful error messages. You know when DCGs are the right
tool and when recursive descent or `parsing_utils` is better. You can write stateful
DCGs that thread extra information through the parse. You know how to handle left
recursion. You know why `phrase/2` doesn't exist and can explain what the DCG
transformation does to any rule.

#### Depth sequence

**Level 1 — Introduction (existing)**
- `katas/parsing/01-dcg-basics/`, `02-dcg-goals/`

**Level 2 — Determinism in DCGs**
- This is covered partly in the determinism pillar but deserves dedicated parsing
  treatment. `katas/parsing/04-dcg-determinism/` (new):
  - Multiple DCG clauses always infer `multi` or `nondet` because Mercury cannot prove
    mutual exclusion. The standard fix: rewrite with if-then-else throughout.
  - The `det` DCG: a grammar where every rule always consumes exactly the expected input.
    Example: a fixed-format date parser `YYYY-MM-DD`. Show that if-then-else makes every
    alternative `det` (succeeds with an error token) rather than `semidet`.
  - The `semidet` DCG: a grammar that may fail at any point. What the failure means for
    the caller (parse error at that position). Show that `( rule --> ...  ; [] )` is
    dangerous — the empty alternative always succeeds, hiding failures.
  - `det` vs `semidet` for the top-level rule: if the top-level rule is `det`, parse
    errors become explicit error values; if `semidet`, parse failure propagates naturally.
    Tradeoffs.

**Level 3 — Left recursion**
- `katas/parsing/05-left-recursion/` (new):
  - The left-recursive grammar loops: `expr --> expr, [+], term | term`. Mercury's
    DCGs are essentially Prolog DCGs: pure top-down, depth-first. Left recursion causes
    infinite recursion before consuming any input.
  - The standard fix: accumulator-based right-to-left parsing. `expr_rest` accumulates
    the result, consuming operators and terms until none remain. This is essentially
    operator-precedence parsing via recursive descent.
  - Write a fully left-associative expression parser for `+ - * /` with correct
    precedence. Verify on `"10 - 3 - 2"` (should give 5, not 9). Verify on
    `"3 + 4 * 2"` (should give 11, not 14).
  - Optional: Pratt parsing (top-down operator precedence) as an alternative when the
    operator table is large or dynamic.

**Level 4 — Error recovery**
- `katas/parsing/06-error-recovery/` (new):
  - A parser that simply fails on error gives the caller no information about what went
    wrong or where. Better: return a structured parse result
    `parse_result(T) ---> ok(T) ; error(int, string)` where `int` is position and
    `string` is the error message.
  - Implement this for the expression tokenizer: instead of failing silently on an
    unexpected character, return `error(Pos, "unexpected character 'X'")`.
  - Error recovery strategies: panic mode (skip tokens until a known synchronization
    point), error productions (add `error_expr` to the AST), continuation after errors.
  - The fundamental tension: a `semidet` grammar that fails cleanly vs. a `det` grammar
    that returns error values. Show both approaches and the resulting API differences.

**Level 5 — Stateful DCGs**
- `katas/parsing/07-stateful-dcg/` (new):
  - DCG rules receive two hidden list arguments. Adding a third argument threads extra
    state through the parse without changing the DCG syntax at all.
  - Build a tokenizer that tracks line and column numbers. The extra state is
    `pos ---> pos(line :: int, col :: int)`. Every `[C]` terminal updates the position.
  - Build an expression parser that tracks a symbol table: identifiers are looked up
    as they are parsed; undeclared identifiers produce an error production rather than
    a parse failure.
  - Show why `!State` notation works in DCG rules — the pre/post state arguments are
    just extra DCG arguments named with the state pair syntax.

**Level 6 — Packrat parsing via tabling**
- `katas/parsing/08-packrat/` (new):
  - Standard DCGs backtrack, which can give exponential time for ambiguous or
    nearly-ambiguous grammars. Adding `pragma memo` to the top-level rules turns the
    parser into a packrat parser: each rule is evaluated at most once per position.
  - Build a grammar for a nearly-ambiguous language (e.g., a grammar with common
    prefixes: `s --> a, b, c | a, b, d`). Measure parse time on a long input with
    and without tabling.
  - The constraint: tabled DCG rules must be `det` or `semidet` (not `nondet`); tabling
    nondet predicates requires different pragmas. Show the error and the workaround.

**Level 7 — DCG semantics**
- `katas/parsing/09-dcg-desugar/` (new):
  - Write a DCG rule desugarer in Mercury. Input: a simplified representation of a DCG
    rule (an ADT over rules and goals). Output: the expanded Mercury predicate.
  - This forces exact understanding of what `-->` compiles to — every `[terminal]`,
    every `{goal}`, every rule call, every `|` alternative.
  - Extend to handle `pushback notation` (`//3` rules) and state-threading DCGs.

#### Bridge ideas

- **Parser Hardening** (`bridge/07-parser-hardening/`): Start with the `csv_reader.m`
  solution. Task 1: add line number tracking (stateful DCG — thread a `pos` through the
  parse). Task 2: add structured error reporting — instead of silently returning a
  partial parse on malformed input, return `parse_result(list(row))` with error position
  and description. Task 3: implement the full RFC 4180 spec: bare CR (not CRLF) is not a
  valid line ending; files with no trailing newline are valid; verify on edge cases.
  Task 4: measure parse time on a 10,000-row CSV with and without memoization on the
  `field` rule.

- **Expression Language** (`bridge/08-expression-language/`): Start with the
  `tokenizer.m` bridge. Task 1: add a recursive-descent parser over the token stream
  producing an `expr` ADT. Task 2: add correct precedence and left-associativity for
  all four operators plus unary minus. Task 3: add an evaluator. Task 4: add variables
  and a `let` binding. Task 5: add useful error messages with token position. At the
  end, this is a complete interpreter for a tiny expression language — all built by
  incrementally extending the tokenizer bridge.

#### Mastery checkpoint

Implement a parser for a simplified JSON subset: objects `{}`, arrays `[]`, strings,
integers, booleans, and null. Return an ADT `json_value`. Handle whitespace throughout.
Return `parse_result(json_value)` with error position on malformed input. The parser
must be fully `det` (no `semidet` at the top level — errors are values, not failures).
Verify on at least: valid nested objects, arrays of arrays, escaped quotes in strings,
and three distinct malformed inputs.

---

### Pillar 5: Typeclasses

#### What shallow exposure gives you

You can declare a typeclass, write instances for simple types, write predicates
constrained by a typeclass. You know that Mercury does not allow default method
implementations.

#### What deep mastery looks like

You know when to use a typeclass and when higher-order is better (and the answer is
often higher-order — typeclasses solve a specific problem). You can design a typeclass
hierarchy with superclasses and functional dependencies, reason about when FDs are
required and what they guarantee. You understand instance coherence and can predict
whether a given instance will be accepted. You understand the relationship between
typeclasses and existential types — that they solve complementary problems — and you can
use them together.

#### Depth sequence

**Level 1 — Introduction (existing)**
- `katas/type-system/04-type-classes/`

**Level 2 — Typeclass design decisions**
- `katas/type-system/07-typeclass-design/` (new):
  - The central question: typeclass vs. higher-order predicate. The rule:
    - **Use a typeclass** when: you need multiple related operations that must be
      implemented consistently; you want constraint propagation through types; you want
      the instance to be reusable across the codebase without being passed explicitly
    - **Use higher-order** when: you need a single operation; you want to swap
      implementations at runtime; the predicate is local to a function
  - Show both solutions to the same problem: a configurable serializer. Compare verbosity,
    flexibility, and what happens when you need a new instance mid-computation.
  - Show the failure mode of overusing typeclasses: "instance proliferation" — needing
    `newtype` wrappers to get different instances for the same type.

**Level 3 — Superclasses and constraint propagation**
- `katas/type-system/05-typeclass-depth/` (new, already specced above — expand further):
  - Build a hierarchy: `eq(T)` (equality), `ord(T) <= eq(T)` (ordering implies equality),
    `printable(T) <= eq(T)` (must be able to compare for equality to print usefully).
  - Show constraint propagation: a predicate `print_sorted(list(T), !, !IO) is det
    <= (printable(T), ord(T))` — the constraint set is the union of both superclass
    constraints, and the compiler checks that any `T` passed satisfies all of them.
  - Show what happens when you forget a superclass constraint: the compiler reports a
    missing instance, not a missing import, which can be confusing.
  - Write instances for `int`, `string`, and a custom `point ---> point(float, float)`
    for all three typeclasses. Observe that defining `ord(point)` requires defining
    `eq(point)` first (the superclass instance must exist).

**Level 4 — Functional dependencies**
- Part of `katas/type-system/05-typeclass-depth/` (new):
  - Without FDs: `serialize(T, Format)` allows `serialize(int, xml)` and
    `serialize(int, json)` simultaneously. This is valid but creates ambiguity at call
    sites: `serialize(42, _)` — which format?
  - With FD `| T -> Format`: Mercury infers the format from the type. There can only be
    one `Format` for each `T`. The ambiguity disappears.
  - Show a real use case: a `stream_reader(S, Token)` typeclass with FD `S -> Token` —
    each stream type `S` produces a unique token type. Prevents accidentally mixing
    token types from different streams.
  - The cost of FDs: they are more restrictive. You cannot have `serialize(int, xml)` and
    `serialize(int, json)` as separate instances. The FD commits you.

**Level 5 — Instance coherence**
- `katas/type-system/08-instance-coherence/` (new):
  - Mercury requires at most one instance per typeclass/type combination (globally, across
    all modules). This is instance coherence — it prevents the same type having
    different instances in different modules from causing unpredictable dispatch.
  - Show the error: defining `printable(int)` in two modules and importing both.
  - The orphan instance problem: an instance defined in a module that imports neither the
    typeclass module nor the type module. Mercury forbids orphan instances. Show the
    error and why the rule exists.
  - `newtype` wrappers as the solution: `metres ---> metres(float)` can have a different
    `printable` instance than `float`. Show the wrapper pattern.
  - Contrast with Haskell's orphan instance problem (allowed but warned, can cause
    incoherence across packages). Mercury chose the stricter rule.

**Level 6 — Typeclasses and existential types together**
- `katas/type-system/06-existential-types/` (existing, expand):
  - The relationship: typeclasses enable uniform dispatch; existential types enable
    heterogeneous storage. Together they enable OOP-style dispatch in a typed functional
    language.
  - Build a plugin registry: `map(string, some_plugin)` where
    `some_plugin ---> some [T] (plug(T) => runnable(T))`. The `runnable` typeclass
    requires `run(T::in, io::di, io::uo) is det` and `describe(T::in) = string`.
    Register plugins at startup, run them by name.
  - The cost: existential quantification prevents the compiler from knowing `T` at call
    sites. Every dispatch is via the typeclass dictionary. This is functionally identical
    to virtual dispatch in OOP.
  - Show the failure: trying to extract `T` from a `some [T] wrap(T)` without a
    typeclass constraint. The compiler rejects it because it cannot know what `T` is.
    This is the "existential escape" problem from `koans/advanced/02-existential-escape/`.

#### Bridge ideas

- **Typeclass Refactor** (`bridge/09-typeclass-refactor/`): Start with `expr_eval.m`
  where the evaluator is concrete (`eval(env, expr) = maybe(int)`). Task 1: parameterize
  the numeric type — replace `int` with a type parameter `N` constrained by a typeclass
  `numeric(N)` with operations `add`, `sub`, `mul`, `div_maybe`, `of_int`. Task 2:
  write instances for `int` and `float`. Task 3: write an instance for `rational`
  (implement `rational ---> rational(int, int)` with exact division). Task 4: show that
  the same evaluator expression tree works over all three numeric types without any
  change to the evaluator code.

#### Mastery checkpoint

Design and implement a `collection(C, T)` typeclass representing any collection type
`C` that stores elements of type `T`, with a functional dependency `C -> T`. Methods:
`empty(C::uo) is det`, `insert(T::in, C::di, C::uo) is det`, `member(T::out, C::in)
is nondet`, `size(C::in, int::out) is det`. Write instances for `list(T)`, `set(T)`,
and `map(int, T)` (where the "element" type is the value type). Write a generic
`insert_all(list(T)::in, C::di, C::uo) is det <= collection(C, T)`. Demonstrate all
three instances from a single `main`.

---

### Pillar 6: Concurrency

#### What shallow exposure gives you

You can use `&` for parallel conjunction. You can spawn a thread and wait on a
semaphore. You know channels exist.

#### What deep mastery looks like

You can reason about what the parallel grade actually provides. You know the exact
conditions under which `&` is legal (both branches must be `det` or `cc_multi`). You
can design deadlock-free concurrent programs using channels. You understand the
relationship between Mercury's parallelism model and its mode system — why unique values
cannot safely be shared across threads. You can profile a parallel program and explain
its speedup (or lack thereof).

#### Depth sequence

**Level 1 — Introduction (existing)**
- `katas/concurrency/01-parallel-conjunction/`, `02-threads/`, `03-concurrent-io/`

**Level 2 — Granularity and spark cost**
- `katas/concurrency/04-granularity/` (new):
  - A parallel conjunction creates a "spark" — a lightweight work item that may or may
    not be stolen by another CPU. Spark creation has overhead. For small work units, the
    spark overhead exceeds the parallel benefit.
  - Build a benchmark: parallel sum over a list, with configurable chunk size. Measure
    time for chunk sizes of 1, 10, 100, 1000, 10000 elements. Plot the crossover point.
  - `sequential_and/2` as the escape hatch: when the threshold check says "do this
    sequentially," `sequential_and(A, B)` runs both goals sequentially in a context
    that looks parallel to the compiler (satisfies the `det` requirement) but does not
    create sparks.
  - Mercury's work-stealing scheduler: understand that `&` creates a spark on the
    *right* branch and continues with the left. The right spark may be stolen by an
    idle CPU. If no CPU is idle, it runs sequentially after the left branch. The
    asymmetry matters for task sizing.

**Level 3 — Deadlock patterns**
- `katas/concurrency/05-deadlock/` (new):
  - The classic dining philosophers in Mercury. Show the deadlock. Fix with resource
    ordering (always acquire lower-numbered fork first). Verify: 5 philosophers running
    for 10 seconds without deadlock.
  - The two-channel deadlock: thread A writes to channel 1 and reads from channel 2;
    thread B writes to channel 2 and reads from channel 1. If both channels are
    unbuffered and both threads block on write, deadlock.
  - The canonical avoidance pattern: never hold more than one lock (semaphore) at a
    time when acquiring another. Restructure the dining philosophers to use a single
    "table resource" semaphore.
  - Identifying deadlock potential from structure alone, without running the program.

**Level 4 — Parallel map and fold**
- `katas/concurrency/06-parallel-map-fold/` (new):
  - Implement `par_map(pred(T::in, U::out) is det, list(T)::in, list(U)::out) is det`
    using `thread.spawn` and channels. Each worker takes one element, processes it,
    writes the result to its dedicated result channel. The collector reads from all
    channels in order. Order preservation is the hard part.
  - Implement `par_fold(pred(T::in, acc::in, acc::out) is det, list(T)::in, acc::in,
    acc::out) is det` — the fold must be sequential, but the *preparation* of each
    element (if expensive) can be parallel. Show a "map-then-fold" that parallelizes
    the map step.
  - Show why a naive parallel fold (forking the accumulator) is incorrect: the
    accumulator is not duplicated across branches — and even if it were, combining the
    results requires the fold to be associative and the initial value to be the identity.
    Mercury's type system does not enforce this. Document it.

**Level 5 — Uniqueness and threads**
- `katas/concurrency/07-uniqueness-and-threads/` (new):
  - A `unique` value cannot be passed to two threads simultaneously — if both threads
    could modify it, the result would be undefined. Mercury's mode system prevents this
    structurally: a `di`/`uo` argument can only be passed to one computation at a time.
  - Show the error: attempting to pass a unique array to two parallel conjuncts. Observe
    the mode error. The fix: convert to `version_array` before the parallel section.
  - `io.mutvar` as the thread-safe shared state mechanism: each thread reads and writes
    through the I/O state, which serializes access. Show that two threads writing to the
    same mutvar without synchronization still produces a race on the read-modify-write
    cycle. Add a semaphore mutex. Verify with the counter-increment test.
  - The philosophical point: Mercury's mode system gives you data-race freedom on unique
    values for free. The only data races that can occur are on values passed through
    `!IO` (mutvars, channels) — and those are explicit in the code.

**Level 6 — Deterministic parallelism**
- `katas/concurrency/08-deterministic-parallelism/` (new):
  - `&` guarantees that the parallel program has the same logical result as the
    sequential program — because both branches are `det`. This is deterministic
    parallelism: the program is parallel but not concurrent in the sense that its result
    is independent of scheduling.
  - Compare to `thread.spawn`: spawning creates true concurrency where the result can
    depend on interleaving. Mercury offers both. `&` for embarrassingly parallel
    divide-and-conquer; `spawn` for long-running concurrent services.
  - Show the boundary: a program using `&` that gets a speedup proportional to the
    number of cores. A program using `spawn` where the speedup is bounded by I/O wait.
  - Mercury's par-conjunct analysis: the compiler proves that two conjuncts do not share
    mutable state (beyond what they explicitly communicate through unique values). This
    is the structural guarantee that makes `&` sound.

#### Bridge ideas

- **Parallel Pipeline** (`bridge/10-parallel-pipeline/`): Start with `pipeline.m`
  (bridge 02). Task 1: parallelize the filter and transform steps using `&` — both
  are `det`, so this is legal; verify correctness. Task 2: add a bounded-buffer channel
  between the filter and transform stages — this decouples the two steps and allows
  each to run at its own rate. Task 3: add backpressure: if the channel is full, the
  producer blocks; if empty, the consumer blocks. Task 4: add a supervisor thread that
  detects worker failure (channel closure) and restarts it.

#### Mastery checkpoint

Implement a parallel web-crawler stub (no actual HTTP — use a provided `fetch_page`
predicate that takes a URL and returns `list(string)` of outgoing links after a
simulated delay). Use a work queue (channel), a pool of N worker threads, and a visited
set (mutvar + semaphore mutex). The crawler should: terminate when the queue is empty
and all workers are idle; return a `set(string)` of all discovered URLs; handle
duplicate links without revisiting.

---

### Pillar 7: Type System Depth

This is less a single pillar than a collection of advanced type system topics that don't
fit neatly into the existing `type-system/` kata track. Each deserves its own treatment.

#### Phantom types

- `katas/type-system/09-phantom-types/` (new):
  - A phantom type carries a type parameter that does not appear in any constructor.
    Example: `metres ---> metres(float)` and `seconds ---> seconds(float)` are
    different types but isomorphic. `phantom(unit, value) ---> phantom(value)` with
    `unit` as a phantom parameter.
  - Build a type-safe unit system: `quantity(metres)`, `quantity(seconds)`,
    `quantity(metres_per_second)`. Define `divide : quantity(metres) -> quantity(seconds)
    -> quantity(metres_per_second)`. Show that `divide(metres(100.0), metres(10.0))` is
    a type error.
  - Phantom types as compile-time state machines: `file_handle(open)` vs
    `file_handle(closed)`. `open_file : string -> file_handle(closed) -> (file_handle(open), res)`.
    `close_file : file_handle(open) -> file_handle(closed)`. Reading a closed file is
    a type error.
  - Note: Mercury's phantom types are simpler than Haskell's because there is no
    kind system — phantom type parameters must be phantom in all constructors of the type.

#### GADTs (approximated)

- `katas/type-system/10-gadts/` (new):
  - Mercury does not have GADTs (generalized algebraic data types). But many GADT use
    cases can be approximated using typeclasses + existential types.
  - Classic GADT: a well-typed expression evaluator where the type encodes the result type.
    `expr(int) ---> lit(int) ; add(expr(int), expr(int))`.
    `expr(bool) ---> bool_lit(bool) ; eq(expr(int), expr(int))`.
    `eval : expr(T) -> T`.
    In Mercury: approximate with `some [T] (expr(T) => evaluable(T))` — the typeclass
    provides the `eval` method. The approximation is less safe (the type of `eval`'s
    result must be extracted, not inferred) but workable.
  - Discuss what the approximation loses and what it retains.

---

### Integration: Cross-Pillar Exercises

These are the ceiling exercises — programs that require multiple pillars to work
together and cannot be written by pattern-matching on any single pillar's examples.
They belong as advanced puzzles or bridges added after the individual pillar sequences
are complete.

#### Integration 1: Determinism × Mode system

**`puzzles/advanced/03-bidirectional-search/`** — A search predicate with two modes:
`(problem::in, solution::out) is semidet` (forward: find a solution for a problem) and
`(problem::out, solution::in) is nondet` (reverse: generate all problems that have a
given solution). The forward mode uses constraint propagation (a heuristic search); the
reverse mode is genuinely nondeterministic. Two different clause bodies, `pragma
promise_equivalent_clauses`. Show that the determinism is correct for each mode
independently, and that the equivalence claim is valid.

#### Integration 2: Higher-order × Determinism

**`puzzles/advanced/04-combinator-library/`** — A parser combinator library where
each combinator's determinism is reflected in its type. Base combinators: `pure(T) is
det`, `fail is failure`, `item(T) is semidet`, `satisfy(pred is semidet) is semidet`.
Derived: `sequence(P, Q)` (determinism = lub(det(P), det(Q))), `choice(P, Q)`
(determinism = lub(det(P), det(Q))), `many(P)` (always `det` — returns `list`). The
library must be written so that the Mercury determinism checker verifies the claims at
each combinator's definition. Show that `choice(det_parser, det_parser)` is `det` and
`choice(semidet_parser, semidet_parser)` is `semidet`.

#### Integration 3: DCGs × Typeclasses

**`puzzles/advanced/05-generic-parser/`** — A parser parameterized by a `token_stream`
typeclass. The typeclass: `token_stream(S, T) | S -> T` with methods `next(S::di,
S::uo, T::out) is semidet` and `position(S::in, int::out) is det`. Write a grammar for
arithmetic expressions in terms of this typeclass — no mention of `list(char)`. Then
provide two instances: one for `list(char)` (character-level parsing) and one for
`list(token)` (token-level parsing). The same grammar works over both without
modification.

#### Integration 4: Typeclasses × Existential types

**`puzzles/advanced/06-plugin-architecture/`** — A runtime-extensible plugin system.
The `plugin` typeclass: `run(T::in, config::in, io::di, io::uo) is det`,
`name(T::in, string::out) is det`, `usage(T::in, string::out) is det`. A plugin
registry: `map(string, some [T] (registered_plugin(T) => plugin(T)))`. Load plugins
from a list of registered factories, look up by name, run. The hard part: the registry
type must be able to store plugins of heterogeneous concrete types.

#### Integration 5: Concurrency × Mode system

**`puzzles/concurrent/03-parallel-pipeline-with-unique-state/`** — A three-stage
parallel pipeline where each stage threads a `unique` state token. Stage 1 reads a
file (unique IO), produces `list(string)`. Stage 2 transforms each line (no IO — can
be parallel). Stage 3 writes results (unique IO). The challenge: stages 1 and 3 require
unique IO tokens; stage 2 can run in parallel; the unique IO token cannot be split.
Design the synchronization so that IO happens in stages 1 and 3 sequentially while
stage 2 runs in parallel. Use channels to communicate between stages.

#### Integration 6: Full language exercise

**`puzzles/advanced/07-mercury-in-mercury/`** — A Mercury meta-interpreter written in
Mercury. Input: a simplified subset of Mercury (no modules, no typeclasses, no modes —
just predicates with clauses). Output: the result of running `main`. Implement
unification, backtracking, and a call stack. This requires: discriminated unions (the
AST), higher-order predicates (the interpreter dispatch), determinism reasoning (the
interpreter must be `nondet` in general but can commit choice for `det` programs),
and RTTI-adjacent concepts (representing Mercury terms as Mercury values). This is the
hardest exercise in the curriculum — it requires internalising every pillar.

---

### Depth Bridges Summary

The following bridge exercises extend existing starting points into pillar-depth
territory. Each is listed with the pillar(s) it deepens:

| Bridge | Pillar(s) | Starting point |
|---|---|---|
| `04-determinism-ratchet/` | Determinism | A working nondet search |
| `05-mode-reversal/` | Mode system | `string_to_int/2` |
| `06-pipeline-parameterization/` | Higher-order | `02-pipeline-extend/pipeline.m` |
| `07-parser-hardening/` | DCGs | `csv_reader.m` |
| `08-expression-language/` | DCGs | `03-dcg-extend/tokenizer.m` |
| `09-typeclass-refactor/` | Typeclasses | `expr_eval.m` |
| `10-parallel-pipeline/` | Concurrency | `02-pipeline-extend/pipeline.m` |

These are not standalone exercises — they depend on the learner having worked through
the corresponding pillar's kata sequence first. The bridge makes the pillar concrete;
the kata sequence makes the bridge tractable.
