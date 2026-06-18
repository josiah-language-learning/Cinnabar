# 02 — Parametric polymorphism: generic binary tree

**Concept:** user-defined parametric types, `tree(T)`, polymorphic predicates, `tree_map`

**Not in the Mercury tutorial.** The tutorial uses `list(T)` as a built-in. Writing your
own parametric type is different: you define the type constructors, you write the recursion.

---

## What you will build

A generic binary search tree.

### The type

```mercury
:- type tree(T)
    --->    leaf
    ;       node(tree(T), T, tree(T)).
```

`leaf` has no type parameter — it works for any `T`. `node` carries a left subtree, a
value of type `T`, and a right subtree.

### Predicates to write

```mercury
:- pred insert(T::in, tree(T)::in, tree(T)::out) is det <= (comparable(T)).
:- pred member(T::in, tree(T)::in) is semidet.
:- pred to_sorted_list(tree(T)::in, list(T)::out) is det.
```

`<= (comparable(T))` is a typeclass constraint — `T` must support `compare/3`. This is
how Mercury expresses "T must be orderable." The `comparable` typeclass is built-in.

For `insert`: if the value is less than the node's value, recurse left; if greater,
recurse right; if equal, leave the tree unchanged.

### `tree_map`

```mercury
:- func tree_map(func(T) = U, tree(T)) = tree(U).
tree_map(_, leaf) = leaf.
tree_map(F, node(L, V, R)) =
    node(tree_map(F, L), F(V), tree_map(F, R)).
```

Note the return type: `tree(U)`. The output type parameter is different from the input
type parameter. This is parametric polymorphism working as a type-level function: given a
mapping from `T` to `U`, produce a mapping from `tree(T)` to `tree(U)`. This is `fmap`
from functional programming.

### Test it

Build a `tree(int)` from a list of integers via repeated `insert`. Extract a sorted list
via `to_sorted_list`. Verify it is sorted. Then `tree_map(float, TreeOfInts)` to produce a
`tree(float)`.

---

## Checkpoint

- `insert` + `to_sorted_list` produces a sorted list from any input order
- `member` works correctly
- `tree_map` changes the element type
- You can explain: why does `tree_map` need two type variables (`T` and `U`) while
  `insert` only needs one?
