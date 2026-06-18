# 10 — GADTs (approximated)

**Concept:** Mercury has no GADTs; three approximation strategies and their trade-offs;
what the approximations lose and what they retain

**Not in the Mercury tutorial.**

---

## What GADTs provide

In Haskell, a GADT lets each constructor refine the type parameter:

```haskell
data Expr a where
  LitI :: Int  -> Expr Int
  LitB :: Bool -> Expr Bool
  Add  :: Expr Int  -> Expr Int  -> Expr Int
  Eq   :: Expr Int  -> Expr Int  -> Expr Bool

eval :: Expr a -> a
eval (LitI n)  = n           -- result is Int
eval (LitB b)  = b           -- result is Bool
eval (Add x y) = eval x + eval y
eval (Eq  x y) = eval x == eval y
```

`eval` is a single function whose return type varies per constructor. The type system
guarantees that `eval (Eq ...)` returns `Bool` and `eval (Add ...)` returns `Int`.
You cannot construct `Add (LitB True) (LitI 1)` — the types don't match.

Mercury cannot express this. There is no way to refine a type parameter per
constructor.

---

## Approximation 1: Separate types per result kind

Define `int_expr` and `bool_expr` as distinct types, each with its own `eval`:

```mercury
:- type int_expr  ---> int_lit(int) ; add(int_expr, int_expr) ; ... .
:- type bool_expr ---> bool_lit(bool) ; eq_int(int_expr, int_expr) ; ... .

:- func eval_int(int_expr)  = int.
:- func eval_bool(bool_expr) = bool.
```

**What it retains:** type safety — `add(int_lit(1), bool_lit(yes))` is a type error.
**What it loses:** a single unified `expr` type and single `eval`. Shared structure
(e.g. `if_then_else`) must be duplicated in both types or cross-referenced.

---

## Approximation 2: Union result type

A single `expr` type, a single `eval` returning a tagged union `val`:

```mercury
:- type val  ---> int_val(int) ; bool_val(bool).
:- type expr ---> lit_i(int) ; lit_b(bool) ; add_e(expr, expr) ; eq_e(expr, expr) ; ... .

:- func eval(expr) = val.
```

**What it retains:** a unified expression type and single eval.
**What it loses:** type safety — `add_e(lit_b(yes), lit_i(1))` compiles. The mismatch
is only caught at runtime (or silently produces a fallback). The compiler cannot
prevent ill-typed expressions.

---

## Approximation 3: Typeclass dispatch

Bind expression types to result types via a typeclass:

```mercury
:- typeclass evaluable(Expr, Val) where [
    func tc_eval(Expr) = Val
].

:- instance evaluable(int_expr, int) where [ tc_eval(E) = eval_int(E) ].
:- instance evaluable(bool_expr, bool) where [ tc_eval(E) = eval_bool(E) ].
```

**What it retains:** compile-time dispatch; the result type `Val` is fixed per
expression type; constraints propagate cleanly.
**What it loses:** the same as Approximation 1 — you still need separate types.
The typeclass adds a layer of abstraction but does not unify the expression types.

---

## The honest bottom line

None of the approximations fully replaces GADTs. What you give up:

| Property | Haskell GADTs | Approx 1 | Approx 2 | Approx 3 |
|---|---|---|---|---|
| Single `expr` type | ✓ | ✗ | ✓ | ✗ |
| Single `eval` | ✓ | ✗ | ✓ | ~(via typeclass) |
| Ill-typed expr = compile error | ✓ | ✓ | ✗ | ✓ |
| Return type varies by constructor | ✓ | ✗ | ✗ | ✗ |

---

## What you will build

### `int_expr` and `bool_expr` (Approximation 1)

Separate ADTs. `eval_int` and `eval_bool`. Include `int_if(bool_expr, int_expr, int_expr)`
to show cross-type interaction.

### `val` union + `expr` (Approximation 2)

Single expression type. `eval` returns `val`. Add a fallback for ill-typed expressions
(e.g. `add_e` of two `bool_val`s) — document what the fallback does and why it exists.

### `evaluable(Expr, Val)` typeclass (Approximation 3)

Instances for `(int_expr, int)` and `(bool_expr, bool)`. A constrained function
`show_result(E) = string <= evaluable(E, int)` that calls `tc_eval`.

---

## Checkpoint

- `eval_int(add(int_lit(2), int_lit(3))) = 5`
- `eval_bool(eq_int(add(int_lit(2), int_lit(3)), int_lit(5))) = yes`
- `eval(add_e(lit_i(1), lit_i(2))) = int_val(3)`
- `tc_eval(mul(int_lit(3), int_lit(3))) = 9`
- You can state: what property of GADTs none of these approximations can replicate?
- You can state: what does the union type approximation lose that Approximation 1 retains?
