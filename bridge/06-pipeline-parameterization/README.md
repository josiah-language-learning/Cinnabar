# Bridge: pipeline parameterization

**After:** `katas/foundations/04-higher-order`

**Why Mercury:** passing a higher-order value in Mercury requires more than just a
type — the value's inst tracks whether it's callable and with what argument modes.
A `pred(item)` stored in a variable is `ground` (not callable); only a value with a
fully-specified inst annotation can be passed to `list.filter`. This bridge is where
that distinction stops being theoretical.

`pipeline.m` is a working program that filters a list of items by stock level,
maps them to revenue values, and folds to a total. The filter criterion and revenue
function are hardcoded.

Build and run it first:

```
mmc --make --grade asm_fast.par.gc.stseg pipeline
./pipeline
```

The tasks extract the hardcoded logic into higher-order parameters, then make the
whole pipeline a first-class value.

---

## Extension tasks

### 1. Parameterize the filter

Replace the hardcoded `high_stock` call with a parameter:

```mercury
:- pred run_filter(pred(item::in) is semidet, list(item)::in,
                   list(item)::out) is det.
```

The inst annotation on the predicate parameter is required for Mercury to accept a
`call/2` on it. Without the inst annotation, the mode checker cannot verify the call.

Test it by calling `run_filter` with two different criteria:
- Items with `qty > 15` (the original `high_stock` behaviour)
- Items with `price > 1.0`

### 2. Parameterize the transform

Replace the hardcoded `revenue` function with a parameter:

```mercury
:- pred run_pipeline(pred(item::in) is semidet,
                     func(item) = float,
                     list(item)::in,
                     float::out) is det.
```

The `func(item) = float` type is a higher-order function value. Its inst annotation
in the mode declaration is `in(func(in) = out is det)`.

Test it with:
- The original filter + revenue function
- A weight pipeline: filter by price, transform to `float(qty)` (total units)

### 3. Pipeline as a first-class record

Define a `pipeline` type that bundles the two parameters:

```mercury
:- type pipeline --->
    pipeline(
        filter    :: pred(item::in) is semidet,
        transform :: func(item) = float
    ).
```

Write `run(pipeline::in, list(item)::in, float::out) is det`.

Note: Mercury does not allow inst-annotated types in record field declarations.
The `pred(item::in) is semidet` syntax above will not compile in a field position.
You have two options:

1. Use `pred(item)` (type only) in the field, and accept that Mercury loses track
   of the inst. Calling the stored predicate requires a mode annotation at the
   call site.
2. Skip the record entirely and pass `filter` and `transform` as separate
   higher-order arguments to `run/4`.

Choose one approach, implement it, and document in a comment why you chose it.

### 4. Two pipelines, one fold

Build two pipeline configurations:
- `revenue_pipeline`: filter `qty > 15`, transform to `revenue(Item)`
- `weight_pipeline`: filter `price > 1.0`, transform to `float(Item^qty)`

Write a function `run_all(list(pipeline), list(item)) = list(float)` that applies
each pipeline to the same item list, collecting one result per pipeline.

Use `list.map` with `run` as the higher-order argument.

---

## What you are practising

- Higher-order predicate parameters with inst annotations
- The difference between `pred(item) is semidet` (type) and `pred(item::in) is semidet` (inst)
- Why inst annotations are required at call sites but not in type declarations
- The record-of-functions approach and its limitations in Mercury's inst system
