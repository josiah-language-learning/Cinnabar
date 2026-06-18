# Koan set: recognising mode errors

**Broken concept:** five common mode error classes — reading the error message,
diagnosing the cause, and applying the right fix

## Prerequisites

- `katas/mode-system/01-insts-and-modes` — insts, modes, `in`, `out`, `di`, `uo`
- `katas/mode-system/03-uniqueness-deep` — uniqueness, `di`/`uo`, array modes

---

This koan set has five broken files. Compile each one, read the error, understand
the cause, and fix it. Each file has exactly one class of mode error.

---

## `free_variable.m` — variable not bound in all branches

A variable bound inside one branch of an if-then-else is `free` after the
if-then-else (the else branch didn't bind it). Using the variable afterwards
is a scope error.

```
mmc --make --grade asm_fast.par.gc.stseg free_variable
```

Error: "variable `Value' is ground in some branches but not others."

**Fix:** use the variable *inside* the branch where it is bound, or bind it to a
default value in the else branch so it is always ground after the if-then-else.

---

## `ground_not_unique.m` — aliasing a unique value

`array.set` requires the array argument to be unique (`array_di`). The code passes the
same original array to two separate `set` calls — both would be destructive owners
simultaneously, which violates uniqueness.

```
mmc --make --grade asm_fast.par.gc.stseg ground_not_unique
```

Error: "unique-mode error: the called procedure would clobber its argument."

**Fix:** thread the array: `A0 → set → A1 → set → A2`. Each `set` consumes one
unique value and produces the next. No variable is ever used twice as `di`.

---

## `reverse_mode.m` — calling a forward-only predicate in reverse

`string_to_int` has mode `(in, out)` — it converts a ground string to an int.
The code tries to use it backwards (with the string as free, the int as ground).
Mercury has no `(out, in)` mode for this predicate.

```
mmc --make --grade asm_fast.par.gc.stseg reverse_mode
```

Error: "variable `S' has instantiatedness `free', expected `ground'."

**Fix:** use the right predicate for the right direction. For int-to-string,
use `string.int_to_string`. Mode reversal requires declaring the reverse mode
explicitly (see `bridge/05-mode-reversal`).

---

## `ho_inst_mismatch.m` — higher-order argument determinism mismatch

`apply_to_list` expects `pred(int::in, int::out) is det`. The predicate
`double_if_even` is `semidet`. The *determinism inst* of the higher-order
argument doesn't match — `semidet` is not a subtype of `det`.

```
mmc --make --grade asm_fast.par.gc.stseg ho_inst_mismatch
```

Error: mode error on the higher-order argument (variable has wrong instantiatedness).

**Fix:** change `double_if_even` to `det` — handle the odd-number case by producing
a default value instead of failing.

---

## `unique_clobber.m` — unique output not produced in all branches

A predicate declaring `array(int)::array_uo` as output must *produce* (initialize)
the array in every execution path. The else branch skips the initialization — the
array is still free after that branch, which violates the `uo` mode.

```
mmc --make --grade asm_fast.par.gc.stseg unique_clobber
```

Error: "mode mismatch in if-then-else. The variable `A' is ground in some branches
but not others."

**Fix:** initialize the array in *both* branches. The `uo` mode is a promise: "I
will produce a unique value." Every branch must fulfill that promise.

---

## The underlying pattern

Mode errors are always about *when* a variable is bound vs. *when* it is used,
and *how many times* a unique value is consumed:

| Error | Root cause |
|-------|-----------|
| free variable | variable used before it is bound |
| aliasing (unique) | unique value consumed twice simultaneously |
| reverse mode | predicate called in a mode it was never declared for |
| HO inst mismatch | higher-order argument's determinism doesn't match |
| uo not produced | unique output missing in some branch |
