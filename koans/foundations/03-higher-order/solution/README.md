# Solution: add the inst annotation

The fix is to declare the inst of the `Transform` argument explicitly.

**Option 1: named inst**
```mercury
:- inst int_transform == (pred(in, out) is det).

:- pred apply_first(list(int)::in, pred(int, int)::in(int_transform),
                    list(int)::out) is det.
```

**Option 2: inline inst**
```mercury
:- pred apply_first(list(int)::in,
                    pred(int, int)::in(pred(in, out) is det),
                    list(int)::out) is det.
```

The mode `in(pred(in, out) is det)` says: the argument is ground AND it is specifically
a predicate with one input int and one output int that always succeeds.

Without this, Mercury knows the variable is `ground` (fully instantiated) but does not
know *what kind* of ground thing it is. `list.map` needs to know the inst of the
predicate argument to verify it can be safely called.

## Why is this different from Haskell?

In Haskell, `(Int -> Int)` carries no restriction beyond its type — all functions
can be called with any matching argument. In Mercury, the mode system additionally
tracks *how* a predicate can be called (its determinism, the instantiation states of
its arguments). This extra information must be explicit at higher-order boundaries.
