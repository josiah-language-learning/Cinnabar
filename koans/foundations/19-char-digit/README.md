# Koan: `char.digit_to_int` and else-branch variable scope

**Broken concept:** calling a char predicate that doesn't exist, then using a
variable from an if-then-else condition in the else branch

## Prerequisites

- `katas/foundations/` — char, if-then-else, variable scope

---

```
mmc char_digit_koan.m
```

Two errors fire — fix the first to reveal the second:

1. `undefined symbol 'digit_to_int'/2` in module `char`
2. Variable `Digit` has instantiatedness `free`, expected `ground` (else branch)

---

## What to observe

**Part 1:** `char.digit_to_int` does not exist. The correct predicate is
`char.decimal_digit_to_int/2`:

```mercury
:- pred char.decimal_digit_to_int(char::in, int::out) is semidet.
```

**Part 2:** Variables bound in the **condition** of an if-then-else are in scope
in the **then** branch but NOT in the **else** branch. The else branch runs
precisely when the condition failed — so the condition's bound variables were
never set.

```mercury
( char.decimal_digit_to_int(C, Digit) ->
    use(Digit)          % Digit is bound here ✓
;
    use(Digit)          % Digit is FREE here — mode error ✗
)
```

---

## Your task

1. Replace `char.digit_to_int` with `char.decimal_digit_to_int`.
2. Remove the use of `Digit` from the else branch — it is unbound there.
   Print a different message for the non-digit case.
