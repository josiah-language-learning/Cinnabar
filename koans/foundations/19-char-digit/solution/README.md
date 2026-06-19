# Solution

Two fixes:

1. `char.digit_to_int` → `char.decimal_digit_to_int`
2. The else branch cannot use `Digit` — it was only bound if the condition succeeded.
   Use a different message for the non-digit case.

```mercury
report_char(C, !IO) :-
    ( char.decimal_digit_to_int(C, Digit) ->
        io.format("digit value: %d\n", [i(Digit)], !IO)
    ;
        io.format("not a digit: %c\n", [c(C)], !IO)
    ).
```

Variables bound in the condition of an if-then-else are in scope in the then-branch
(the condition succeeded — the binding happened). They are NOT in scope in the
else-branch (the condition failed — the binding never happened). Using a
condition-bound variable in the else-branch is a mode error: the variable is `free`
where the else-branch expects it to be `ground`.
