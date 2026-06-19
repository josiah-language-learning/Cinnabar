# Solution: add `import_module int`

Add one line to the implementation section:

```mercury
:- import_module int.
```

All four comparison operators (`>`, `<`, `>=`, `=<`) are now in scope.
The program compiles and prints `positive negative zero`.
