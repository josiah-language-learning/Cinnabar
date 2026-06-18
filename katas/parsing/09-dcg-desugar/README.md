# 09 — DCG desugaring

**Concept:** what `-->` compiles to; implementing a DCG desugarer; every rule form and
its expansion

**Not in the Mercury tutorial.**

---

## The desugaring rules

Every DCG rule `head --> body` is syntactic sugar for a predicate with two extra list
arguments. The transformation is mechanical:

| DCG form | Desugared Mercury |
|---|---|
| `[t]` (terminal) | `S0 = [t \| S1]` |
| `r(X)` (rule call) | `r(X, S0, S1)` |
| `(A, B)` (sequence) | `A(S0, S1), B(S1, S2)` |
| `(A ; B)` (alternative) | `(A(S0, S) ; B(S0, S))` |
| `{Goal}` (embedded goal) | `Goal, S0 = S1` |
| `[]` (epsilon) | `S0 = S1` |

The hidden list arguments are threaded through every form. Sequence creates a fresh
intermediate variable (`S1`) that connects adjacent rules. Alternative shares the
same input list for both branches.

---

## Pushback rules (`//3`)

A DCG rule can have a third extra argument for "pushback" — tokens to be re-inserted
into the input stream. A `//3` rule has signature `(in_arg, in_list, out_list, pushback_list)`.
This is rarely needed but appears in some tokenizers that peek ahead and put tokens back.

---

## Implementing the desugarer

This kata asks you to write a Mercury predicate that desugares a DCG body represented
as an ADT:

```mercury
:- type dcg_body
    --->    terminal(string)
    ;       rule_call(string)
    ;       seq(dcg_body, dcg_body)
    ;       alt(dcg_body, dcg_body)
    ;       embed(string)              % {Goal}
    ;       empty.                     % []
```

The desugarer takes a `dcg_body`, an input state variable name, and an output state
variable name, and produces a `mercury_goal` — an ADT representing the desugared code.

```mercury
:- pred desugar(dcg_body::in, string::in, string::in, mercury_goal::out) is det.
```

---

## Example

```mercury
% Input DCG body:
seq(terminal("x"), rule_call("r"))

% Desugared with state variables S0 / S:
S0 = [x | S0_1],   -- terminal
r(S0_1, S)          -- rule_call
% Combined as a conjunction:
conj(unify_head("S0", "x|S0_1"), call("r", "S0_1", "S"))
```

The desugarer creates fresh intermediate variable names (`S0_1`, `S0_2`, ...) by
appending `_1`, `_2`, etc. to the input state variable name.

---

## What you will build

### `desugar/4`

Implement desugaring for all six DCG body forms. Use the `mercury_goal` ADT defined
in `start.m`.

### `goal_to_string`

Pretty-print a `mercury_goal` as a Mercury source string. Use this to verify your
desugarer produces sensible output.

### Extension: pushback notation

Add a `pushback(dcg_body, list(string))` constructor to `dcg_body`. Desugaring
a pushback rule requires a third hidden argument carrying the pushed-back tokens.

---

## Checkpoint

- `desugar(terminal("x"), "S0", "S", G)` produces `unify_head("S0", ...)`
- `desugar(seq(A, B), ...)` produces `conj(GoalA, GoalB)` with a fresh intermediate state
- `desugar(alt(A, B), ...)` produces `disj(GoalA, GoalB)` sharing the same state
- `desugar(embed("X = 42"), ...)` produces `conj(pure_goal("X = 42"), state_pass(...))`
- `desugar(empty, "S0", "S", G)` produces `state_pass("S0", "S")`
- You can state from memory: what does `{Goal}` desugar to in a DCG rule?
