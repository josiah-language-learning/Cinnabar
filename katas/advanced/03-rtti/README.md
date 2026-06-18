# 03 — RTTI: generic pretty-printer

**Concept:** `deconstruct.deconstruct/5`, `type_of/1`, `univ`, recursive value inspection,
when RTTI is appropriate vs. a design smell

**Not in the Mercury tutorial.**

---

## Background

Mercury's RTTI (Runtime Type Information) system allows you to inspect any value's
structure at runtime without knowing its type at compile time. Three modules are relevant:

```mercury
:- import_module deconstruct.
:- import_module univ.
:- import_module type_desc.
```

Key operations:
```mercury
% Convert any value to a univ (type-erased value)
:- func univ(T) = univ.

% Get the type descriptor of any value
:- func type_of(T) = type_desc.

% Decompose a value into its functor name, arity, and arguments
:- pred deconstruct(T::in, canonicalize::in,
                    string::out, int::out, list(univ)::out) is det.
```

`deconstruct(Value, Canonicalize, FunctorName, Arity, Args)`:
- `FunctorName`: the constructor name as a string (e.g., `"node"`, `"[]"`, `"1"`)
- `Arity`: number of arguments
- `Args`: list of `univ`-wrapped arguments (type erased)

---

## What you will build

A generic pretty-printer that displays any Mercury value as an indented tree.

### The pretty-printer

```mercury
:- import_module deconstruct.
:- import_module univ.
:- import_module int.
:- import_module string.
:- import_module list.

:- pred pretty_print(T::in, io::di, io::uo) is det.
pretty_print(Value, !IO) :-
    pretty_print_univ(univ(Value), 0, !IO).

:- pred pretty_print_univ(univ::in, int::in, io::di, io::uo) is det.
pretty_print_univ(U, Depth, !IO) :-
    Value = univ_value(U),
    deconstruct(Value, canonicalize, Functor, Arity, Args),
    Indent = string.duplicate_char(' ', Depth * 2),
    ( Arity = 0 ->
        io.format("%s%s\n", [s(Indent), s(Functor)], !IO)
    ;
        io.format("%s%s(\n", [s(Indent), s(Functor)], !IO),
        list.foldl(pretty_print_univ_indented(Depth + 1), Args, !IO),
        io.format("%s)\n", [s(Indent)], !IO)
    ).

:- pred pretty_print_univ_indented(int::in, univ::in, io::di, io::uo) is det.
pretty_print_univ_indented(Depth, U, !IO) :-
    pretty_print_univ(U, Depth, !IO).
```

### Test it

```mercury
:- type tree(T) ---> leaf ; node(tree(T), T, tree(T)).

main(!IO) :-
    Tree = node(node(leaf, 1, leaf), 2, node(leaf, 3, leaf)),
    pretty_print(Tree, !IO),
    pretty_print([1, 2, 3], !IO),
    pretty_print(yes("hello"), !IO).
```

Expected for `[1, 2, 3]` (which is `'[|]'(1, '[|]'(2, '[|]'(3, '[]')))`):
```
'[|]'(
  1
  '[|]'(
    2
    '[|]'(
      3
      '[]'
    )
  )
)
```

---

## When RTTI is appropriate

**Good uses:**
- Generic debugging / pretty-printing (this kata)
- Serialization where you don't know the type at compile time
- Testing frameworks that compare values generically

**Design smells:**
- Using `deconstruct` where a typeclass would do the job — a `printable` typeclass
  gives you compile-time guarantees; RTTI gives you runtime fragility
- Using `type_of` to dispatch behavior — that is what typeclasses and existential types are for
- Any place where you find yourself examining type names as strings to make decisions

RTTI is the escape hatch. Reach for typeclasses first.

---

## Checkpoint

- `pretty_print(Tree, !IO)` produces a readable tree output
- `pretty_print([1, 2, 3], !IO)` shows the list cons-cell structure
- `pretty_print(yes("hello"), !IO)` shows `yes("hello")` expanded
- You can state two situations where RTTI is appropriate and two where a typeclass
  would be better
