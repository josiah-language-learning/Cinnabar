# Solution: use `version_array` for shared access

`array(T)` requires unique (`di`/`uo`) access. In a disjunction, the compiler cannot
guarantee uniqueness across branches — it rejects the code.

`version_array(T)` is a persistent functional array: updates return new versions without
consuming the old one. It allows the same array to appear in multiple branches.

```mercury
:- import_module version_array.

main(!IO) :-
    VArr0 = version_array.init(5, 0),
    Flag = yes,
    (
        Flag = yes,
        VArr1 = version_array.set(VArr0, 0, 42)   % VArr0 is not consumed
    ;
        Flag = no,
        VArr1 = version_array.set(VArr0, 0, 0)    % VArr0 still accessible
    ),
    io.write_line(version_array.to_list(VArr1), !IO).
```

## The trade-off

`array(T)` with `di`/`uo`: potentially destructive in-place update (O(1)), but requires
unique ownership — no sharing across branches.

`version_array(T)`: functional update (may copy), allows sharing — fine for all disjunctions.

Use `array(T)` when you need performance and can thread uniquely through the computation.
Use `version_array(T)` when you need to access the same array from multiple code paths.
