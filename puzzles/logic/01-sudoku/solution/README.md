# Sudoku solution notes

## Key design decisions

**Cell ordering:** fill left-to-right, top-to-bottom. Alternatively, fill the most
constrained cell first (fewest legal values) — this is the "minimum remaining values"
heuristic and significantly reduces backtracking for hard puzzles.

**Constraint representation:** use `set(int)` for the set of digits already used in
each row, column, and box. Membership testing is O(log n).

**When to check:** check after every placement, not just at the end. The `valid_placement`
call is cheap (one row + one column + one box = O(9) each) and prunes most branches
immediately.

## The crux: `valid_placement`

```mercury
:- pred valid_placement(grid::in, int::in, int::in) is semidet.
valid_placement(Grid, Row, Col) :-
    get_row(Grid, Row, RowVals),
    no_duplicates(RowVals),
    get_col(Grid, Col, ColVals),
    no_duplicates(ColVals),
    get_box(Grid, Row, Col, BoxVals),
    no_duplicates(BoxVals).

:- pred no_duplicates(list(int)::in) is semidet.
no_duplicates(Vals) :-
    Nonzero = list.filter((pred(V::in) is semidet :- V \= 0), Vals),
    list.sort(Nonzero, Sorted),
    list.remove_dups(Sorted, Deduped),
    list.length(Nonzero, N),
    list.length(Deduped, N).
```

## Generate

`int.nondet_int_in_range(1, 9, Digit)` is the generator — it produces digits 1 through 9
nondeterministically. The constraint predicates prune invalid choices.
