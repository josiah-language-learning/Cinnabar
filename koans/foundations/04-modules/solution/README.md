# Solution: `use_module` in interface, `import_module` in implementation

In `utils.m`, the interface section should use `use_module`:

```mercury
:- interface.
:- use_module string.   % types visible in signatures, names NOT re-exported
```

And the implementation section can still use `import_module`:

```mercury
:- implementation.
:- import_module string.   % names available for use in implementation
```

After this fix, `client.m` no longer has access to `string`'s predicates via `utils`,
so `string.length(G)` in `client.m` fails to compile. The fix for `client.m`:

```mercury
:- implementation.
:- import_module utils.
:- import_module string.   % now explicitly imported
```

## The rule

- `import_module` in **interface**: re-exports to all callers — almost always wrong
- `use_module` in **interface**: types visible in signatures, names stay private — correct
- `import_module` in **implementation**: names available internally — always fine
