# Solution notes

## State threading in Stage 2

The accumulator's state (count, sum, max) is threaded as three explicit `in`
arguments through each recursive call:

```mercury
acc_loop(In, Out, Count0, Sum0, Max0, !IO) :-
    channel.take(In, Item, !IO),
    (
        Item = no,
        channel.put(Out, stats(Count0, Sum0, Max0), !IO)
    ;
        Item = yes(V),
        Count1 = Count0 + 1,
        Sum1   = Sum0 + V,
        Max1   = ( V > Max0 -> V ; Max0 ),
        acc_loop(In, Out, Count1, Sum1, Max1, !IO)
    ).
```

After the recursive call, `Count0`, `Sum0`, `Max0` are never referenced again.
Mercury's mode system verifies this — the variables are `in` (ground on entry)
and not produced as outputs. This is the same linearity constraint that
`array_di` / `array_uo` enforces for heap-allocated arrays.

## Connecting to unique types

If instead of three ints the stage accumulated into an `array`, the pattern would be:

```mercury
array.set(Idx, V, Arr0, Arr1),  % Arr0 :: array_di, Arr1 :: array_uo
acc_loop(In, Out, Arr1, Idx + 1, !IO)
```

`Arr0` is consumed by `array.set` (mode `array_di` = destructive input). `Arr1`
is the fresh result (mode `array_uo` = unique output). Using `Arr0` after this call
would be a type/mode error. The compiler enforces the same "use it once, then it's
gone" rule that the explicit int threading follows by convention.

## IO ownership across threads

`thread.spawn` takes a closure of type `pred(io::di, io::uo) is cc_multi`. The
spawned thread receives its own IO token; the parent thread continues with its
own. The type system prevents the parent from using the child's IO token, and
vice versa.

Consequence: IO output from multiple threads can interleave at the OS level.
Keeping all user-visible output in a single thread (Reporter, Stage 3) avoids
interleaved output without any additional locking.

## cc_multi vs multi

`thread.spawn` is declared `cc_multi` — it commits to one IO execution path even
though internally there is nondeterminism (which thread runs when). A predicate
calling it must also be `cc_multi`. The distinction:

- `multi`: the compiler models all possible execution paths as observable
- `cc_multi`: the compiler models only one committed path (the one that actually
  executes); nondeterminism is hidden inside

`main` and all predicates in the spawn chain must be `cc_multi`. Attempting `det`
or `multi` for a predicate calling `thread.spawn` produces a determinism mismatch.

## Answers to design questions

**Q1: Partial updates every K items**
Chan2 would change from `channel(stats)` to `channel(maybe(stats))`. The
accumulator sends `yes(partial_stats)` every K items and `no` at the end. The
reporter loops on `take` until it receives `no`. The accumulator would thread
an additional `int` argument for the current-batch count.

**Q2: array_di alias prevention**
`Arr0` would have mode `array_di`. After `array.set(Idx, V, Arr0, Arr1)`,
Mercury marks `Arr0` as "clobbered" — it has been destructively consumed.
Any subsequent reference to `Arr0` is a mode error. The system cannot prevent
you from reading a clobbered array at the C level, but Mercury's mode analysis
ensures no compiled code ever does so.

**Q3: cc_multi vs multi**
`multi` says "this predicate computes multiple solutions." A procedure body that
calls `thread.spawn` and then continues is not truly nondeterministic — it runs
exactly once (commits to the one real execution path). Using `multi` would
require the compiler to model backtracking, which doesn't apply. `cc_multi`
(committed choice multi) correctly captures "there is conceptual nondeterminism
but we commit to one choice and never backtrack."
