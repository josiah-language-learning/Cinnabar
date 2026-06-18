# Cinnabar Project — Final Ratings & Concrete Fixes

---

## Category Ratings

| # | Category | Rating | Summary |
|---|---|---|---|
| 1 | **Koans** | **4.5 / 5** | Excellent flaw selection, plausible broken code, correct fixes. Best solution READMEs in the project. Docking for missing error previews and inconsistent hint levels. |
| 2 | **Katas** | **3.5 / 5** | Strong step ordering and checkpoint questions. Undermined by missing module skeletons, floating code snippets, and a wrong `list.assoc` reference. |
| 3 | **Puzzles** | **3.0 / 5** | Problem statements are well-written (4.5/5), but solutions contain **4 compilation errors** that block any learner who tries to run them. |
| 4 | **Code Accuracy (.m files)** | **3.0 / 5** | 4 compilation errors, 1 non-idiomatic operator, 2 cosmetic dead-code issues. The `string.string` misconception is systematic. |
| 5 | **Overall Curriculum Design** | **3.5 / 5** | Strong three-format arc and logical track ordering where visible. Critical gaps: missing mode-system track, no bridge tier, no prerequisite cross-references, empty advanced tracks. |
| 6 | **Top-level README** | **N/A** | File not provided. Must be created. |

---

## Top Concrete Fixes Per Category

### Koans (3 fixes)

| # | File | Line | Issue | Fix |
|---|---|---|---|---|
| K-1 | `koans/foundations/01-maybe/maybe_koan.m` | 10 | `:- import_module string.` imported but never used | Remove the unused import |
| K-2 | `koans/foundations/03-higher-order/ho_koan.m` | 9–10 | `negate/2` defined but never used; `:- import_module string.` unused | Remove both dead code items |
| K-3 | All 4 koan READMEs | Various | No prerequisite listing, no error-preview sentence | Add `## Prerequisites` section + one-sentence error preview (e.g., *"The error will say `pred(int,int)` is not compatible with `func(int)=int`"*) |

### Katas (5 fixes)

| # | File | Line | Issue | Fix |
|---|---|---|---|---|
| KA-1 | `katas/foundations/02-maybe/README.md` | ~20 | References `list.assoc` — does not exist in Mercury's `list` module | Change to `assoc_list.search` (from the `assoc_list` module) or remove the suggestion |
| KA-2 | `katas/foundations/02-maybe/README.md` | entire file | No module skeleton shown (`:- module`, `:- interface`, `:- implementation`, `:- import_module`) | Add a minimal "Getting started" section showing the required boilerplate, including `:- import_module maybe.` and `:- import_module string.` |
| KA-3 | `katas/foundations/04-higher-order/README.md` | ~15 | `sample_items = [...]` shown without `:- func sample_items = list(item).` declaration | Add the declaration above the definition |
| KA-4 | `katas/foundations/04-higher-order/README.md` | Steps 2–4 | Code snippets (`list.filter`, `list.map`, `list.foldl2`, `Transform = double_qty`) shown as floating goal sequences, not inside any predicate | Wrap each snippet inside `main(!IO)` or explicitly state "put this inside main" |
| KA-5 | `katas/type-system/04-type-classes/README.md` | ~55 | Comment `% default: label(_) = "item"` next to deliberately invalid `func label(T) = string` implies near-valid syntax | Change to `% what you might want, but Mercury does not support default methods:` |

### Puzzles — Expression Evaluator (3 fixes)

| # | File | Line | Issue | Fix |
|---|---|---|---|---|
| PE-1 | `puzzles/data-structures/02-expression-evaluator/solution/expr_eval.m` | ~46 | Missing `:- import_module list.` — `list.foldl/3` is called but `list` not imported | Add `:- import_module list.` to implementation imports |
| PE-2 | `puzzles/data-structures/02-expression-evaluator/solution/expr_eval.m` | ~47 | `string.string(Result)` — **does not exist** in Mercury's `string` module. No polymorphic `show`/`toString` exists. Compilation error. | Replace with: `( Result = yes(N) -> io.format("yes(%d)\n", [i(N)], !IO) ; io.write_string("no\n", !IO) )` |
| PE-3 | `puzzles/data-structures/02-expression-evaluator/solution/expr_eval.m` | ~47 | After fixing PE-2, `:- import_module string.` becomes dead | Remove the unused `string` import |

### Puzzles — Calculator (3 fixes)

| # | File | Line | Issue | Fix |
|---|---|---|---|---|
| PC-1 | `puzzles/parsing/01-calculator/solution/calculator.m` | ~20 | `phrase(tokens(Tokens), Chars)` used but `dcg` module not imported. `phrase/2` is not in `list` in all Mercury grades. | Add `:- import_module dcg.` to implementation imports |
| PC-2 | `puzzles/parsing/01-calculator/solution/calculator.m` | ~82 | `string.string(calculate(Expr))` — **same systematic bug** as PE-2. Does not exist. | Replace with: `( calculate(Expr) = yes(V) -> io.format("%s = yes(%d)\n", [s(Expr), i(V)], !IO) ; io.format("%s = no\n", [s(Expr)], !IO) )` |
| PC-3 | `puzzles/parsing/01-calculator/solution/calculator.m` | ~58 | `{ F \= 0 }` uses term-level disequality instead of arithmetic `=\=` | Change to `{ F =\= 0 }` with a comment: `% use =\= for arithmetic, not \= (term disequality)` |

### Code Accuracy — Systematic Issue (1 fix)

| # | Files | Issue | Fix |
|---|---|---|---|
| SYS-1 | `expr_eval.m` (PE-2), `calculator.m` (PC-2) | Both assume Mercury has a polymorphic `string.string/1` (like Haskell's `Show`). It does not. | Fix both instances. Add a note in both solution READMEs: *"Mercury has no universal Show/typeclass — use explicit per-type formatting like `string.int_to_string/1`."* |

### Curriculum Design (3 fixes)

| # | Location | Issue | Fix |
|---|---|---|---|
| CD-1 | All puzzle READMEs | No prerequisites listed — learner doesn't know which koans/katas to complete first | Add `## Prerequisites` section to each puzzle README linking to specific koans and katas |
| CD-2 | Project root | No top-level `README.md` exists | Create one with: project description, target audience, learning path diagram, "pick your entry point" guide, build instructions (`mmc --make --grade hlc.gc.pregen`) |
| CD-3 | Between katas and puzzles | No bridge tier — jump from guided build to open-ended design is steep | Add 2–3 "modification exercises" (working code the learner extends) or tighten earliest puzzles with more structured sub-tasks |

---

## Severity Summary

| Severity | Count | Items |
|---|---|---|
| **Compilation error** (blocks learners) | **4** | PE-1, PE-2, PC-1, PC-2 |
| **Non-idiomatic code** (confusing to learners) | **1** | PC-3 (`\=` vs `=\=`) |
| **Missing content** (blocks progression) | **3** | KA-2 (no module skeleton), CD-2 (no root README), CD-3 (no bridge tier) |
| **Dead code / unused imports** (cosmetic) | **3** | K-1, K-2, PE-3 |
| **Incorrect reference** (misleading) | **1** | KA-1 (`list.assoc` doesn't exist) |

**The 4 compilation errors are P0.** Any learner who tries to compile a puzzle solution will hit them immediately. These should be fixed before the curriculum is released or shared further.

> Tokens: 48k sent, 2.5k received. Cost: $0.0051 message, $0.09 session.  
