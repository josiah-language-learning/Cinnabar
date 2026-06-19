# Solution

Replace `!:N` on the right-hand side with `!.N`:

```mercury
double_it(!N) :-
    !:N = !.N * 2.
```

`!.N` is the current (input) value — it is ground at this point and can be used
in expressions. `!:N` is the new (output) value — it is free until this line
assigns it. After the assignment, `!:N` is ground and the predicate can exit.

A useful mnemonic: the dot in `!.N` is a "full stop" — you are reading a value
that is complete and known. The colon in `!:N` is a "label" — you are writing a
slot that will hold the next value of N.

The unused-variable warning about `STATE_VARIABLE_N_0` (`!.N`) that fires in the
broken version is a reliable secondary signal: if the old value of a state
variable is never read, it is almost always because you accidentally wrote `!:X`
where you meant `!.X`.
