# Solution

Use `Arr1` (the output of the first set) as the input to the second set:

```mercury
build_array(Result) :-
    array.init(5, 0, Arr0),
    array.set(0, 10, Arr0, Arr1),
    array.set(1, 20, Arr1, Arr2),    % Arr1, not Arr0
    array.set(2, 30, Arr2, Result).
```

Each `array.set` call consumes its input and produces a new array handle. The
`N0` / `N` naming convention (here `Arr0`, `Arr1`, `Arr2`) makes the chain
explicit: each variable name corresponds to one state in the array's evolution.

This is the same linear-chain discipline as `!IO`. Unlike `version_array`, which
uses persistent (copy-on-write) semantics and can be read from multiple points,
`array` is genuinely in-place — sharing is prohibited by the uniqueness mode.
