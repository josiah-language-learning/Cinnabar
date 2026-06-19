# Cinnabar coverage review: Mercury language breadth and depth

*Reviewed 2026-06-19 by Claude Opus 4.8. Surveyed the full on-disk inventory of
`katas/`, `koans/`, `bridge/`, and `puzzles/`, the track READMEs, and a sample of
exercises at the foundations / advanced / integration boundaries.*

- **Breadth: 8/10.** Cinnabar covers nearly every post-tutorial Mercury topic, including
  several most curricula skip entirely: inst hierarchies, committed-choice determinism,
  tabling/packrat, RTTI, the full FFI attribute space, STM, and solver-type mechanics.
- **Depth: 7.5/10.** It pushes well past intermediate in modes, determinism, parsing,
  concurrency, and FFI. The one real depth ceiling is solver types/CLP, which stop at the
  language hook because no constraint engine exists; and there is no multi-module capstone.

## 1. Breadth — what's covered

The on-disk inventory (which is larger than several track indexes admit — see the README
review) is:

| Track | Katas | Span |
|---|---|---|
| Foundations | 12 | reactivation (7 sub-exercises) → modules, maybe, string, higher-order, map, set, exceptions, built-in types, mode inference, **record update**, **stdlib collections** |
| Type system | 10 | ADTs → parametric → abstract → typeclasses → existentials → **typeclass depth** → **typeclass design** → **instance coherence** → phantom → **GADT approximations** |
| Mode system | 8 | insts/modes → multi-mode → uniqueness → higher-order insts → mode-specific clauses → **inst hierarchy** → **clause selection** → **array vs version_array** |
| Determinism | 7 | six categories → committed choice → scope annotations → multi/nondet → disjunctions → negation → **promise_equivalent_solutions** |
| Parsing | 9 | DCG basics → goals → parsing_utils → determinism → **left recursion** → **error recovery** → **stateful DCG** → **packrat** → **DCG desugar** |
| Tooling | 6 | grades → mdb → profiling → tabling → testing → **property testing** |
| Concurrency | 9 | parallel conjunction → threads → concurrent IO → granularity → deadlock → parallel map/fold → uniqueness+threads → deterministic parallelism → **STM** |
| Advanced | 7 | FFI depth → solver types → RTTI → pragma memo → assoc-list env → **abstract module** → **FFI pragma attributes** |

The bolded items are the ones that lift this from "covers the basics" to "covers the
language." `katas/parsing/09-dcg-desugar` (examining what `-->` compiles into) and
`katas/mode-system/07-clause-selection` (compile-time procedure selection, not Prolog-style
runtime clause choice) are the kind of content that separates fluency-building from a
topic checklist.

**Note on additions since the prior review.** Foundations now carries `10-record-update`
and `11-stdlib-collections`, which fill two gaps that earlier reviews flagged in adjacent
form (record `^`/`:=` syntax as a dedicated exercise; stdlib collection breadth). Those
should be folded into the coverage credit.

## 2. Thin or absent areas

1. **Working constraint logic programming — the largest genuine gap.** I read
   `katas/advanced/02-solver-types/README.md` in its current (rewritten) form: it is now a
   real exercise — working `solver type` declaration with the interface/implementation
   split, the `any` inst, the purity interaction, and the trailing-grade note — and
   `koans/advanced/07-solver-any-inst` drills the `any`-vs-`ground` mode error. That is a
   meaningful improvement over a pure reference kata. But there is still **no backtrackable
   constraint store**: no `domain`/`#=`/`labeling` a learner can run. The logic-puzzle
   track repeatedly uses brute-force generate-and-test (`sudoku.m`, `crypto.m`) where a
   working CLP(FD) would be the natural advanced comparison. `CLP-PLAN.md` documents the
   intended Rust-FFI engine; until something like it lands, this is the one place the
   curriculum teaches *about* a feature rather than *with* it.
2. **No multi-module capstone.** Modules, abstract types, `use_module` vs `import_module`,
   and an abstract-module kata are all present, but nothing makes the learner manage a
   realistic multi-module package with interface boundaries, a build definition, and tests.
   This is the most likely next need for someone moving from tutorial to production Mercury.
3. **Long-tail stdlib by design.** `11-stdlib-collections` helps, but queues/cords,
   digraphs, bitmaps, and term I/O are not individually drilled. This is fine — one
   "choose the representation" bridge would be worth more than one kata per module.

## 3. Depth and progression

Difficulty rises defensibly: everyday types and collections → compile-time invariants
(representation hiding, instantiation, uniqueness, higher-order modes) → those invariants
turned into control flow and grammar → runtime concerns (grades, profiling, parallelism,
STM, FFI, RTTI) → integration in bridges and puzzles. There is no mid-curriculum plateau.

The genuine depth ceiling is solver types (section 2). A small, deliberately limited
finite-domain solver — domains, `=`/`\=`, choice, trailing — would convert the one
language-awareness topic into hands-on practice and make the trailing grade's purpose
concrete.

## 4. Sequencing

The root order (Foundations → Type System → Mode System → Determinism → Parsing, then
Tooling/Concurrency/Advanced) is sound, and advanced puzzles state specific cross-track
prerequisites.

Two concerns, both of which I confirmed:

- **"Any order after the core" is too loose.** `README.md:23` says Tooling, Concurrency,
  and Advanced can be taken in any order, but `katas/advanced/02-solver-types` needs FFI
  knowledge and a non-default trailing grade, and the concurrency track leans hard on
  modes/determinism. Recommend explicit subpaths (Tooling → Concurrency; Advanced 01 FFI →
  02 solver → rest).
- **The reactivation block front-loads hard material.**
  `katas/foundations/00-reactivation/` contains `06-pure-randomness` (mutables, impurity,
  FFI, initialization) ahead of the main Foundations sequence that teaches modules and IO.
  As optional experienced-programmer recall this is fine; as ordinary early progression it
  is a spike. Mark it "advanced recall; defer" or move it.

The dominant sequencing failure, though, is documentary, not conceptual: the stale track
indexes (see README review) mean a learner following local READMEs never sees the later
type-system, parsing, mode-system, determinism, or bridge exercises. The intended sequence
exists in the tree but is invisible through the maps.

## 5. Redundancy and balance

Low and mostly deliberate. Determinism recurs across its own track, modes, parsing,
testing, concurrency, and logic puzzles — appropriate, because it is the concept Mercury
fluency is actually *made of*. Two areas are genuinely over-weighted relative to their
share of practice:

- **FFI/purity error cases**: advanced koans cover missing `will_not_call_mercury`, impure
  foreign procs, export arity, foreign enums, the solver/FFI mode error, and a mutex case —
  excellent specialist coverage, but more real estate than solver types or module-scale
  architecture get. Keep the koans; redirect one *future* FFI exercise toward a practical
  integration project rather than another error case.
- **`promise_equivalent_*` / committed choice**: appears in determinism katas 02 and 07,
  multiple determinism koans, mode-specific clauses, a bridge, and concurrency spawning.
  Defensible, but it needs a stated progression (the guarantee → the procedure-level
  promise → the `[!:IO]`/thread consequence) so it reads as reinforcement, not repetition.

Do **not** trim the mode, determinism, or parsing repetition — that is where the
curriculum builds fluency rather than a checklist.

## Summary

Breadth **8/10**, depth **7.5/10**. The single highest-value addition is a working
finite-domain constraint store (even a small one) to make solver types concrete; the
second is a multi-module capstone. Neither is a release blocker — they are the difference
between "comprehensive" and "complete." (My ratings land essentially where CODEX's did;
the main update is crediting the rewritten solver-types kata and the two new foundations
katas.)
