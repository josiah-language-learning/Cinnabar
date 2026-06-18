# Solution: parametric instance with a typeclass constraint

Instead of declaring an instance for the concrete type `list(int)`, declare it for
the generic `list(T)` with a constraint that `T` must itself be `showable`:

```mercury
% Before (broken):
:- instance showable(list(int)) where [
    show(Ns) = "[" ++ string.join_list(", ", list.map(show, Ns)) ++ "]"
].

% After (fixed):
:- instance showable(list(T)) <= showable(T) where [
    show(Ns) = "[" ++ string.join_list(", ", list.map(show, Ns)) ++ "]"
].
```

`<= showable(T)` is the instance constraint: "this instance applies when T has a
`showable` instance." The compiler uses this to verify that `show(Ns)` can call
`show` on each element.

Now `show([1, 2, 3])` works because `int` has a `showable` instance, so `list(int)`
satisfies `showable(list(T)) <= showable(T)`. And `show([point(...)])` would work too,
as long as `point` had a `showable` instance.

## Why not `list(int)`?

Mercury's typeclass system uses closed-world assumptions — no overlapping instances.
If you had `showable(list(int))` and also `showable(list(T)) <= showable(T)`, they
would overlap for `list(int)`, and the compiler cannot determine which to use.
