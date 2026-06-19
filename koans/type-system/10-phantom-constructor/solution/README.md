# Solution

Add a dummy constructor to each phantom type tag:

```mercury
:- type metres ---> metres_unit.
:- type seconds ---> seconds_unit.
```

`metres_unit` and `seconds_unit` are never constructed at runtime. They exist only
so that Mercury treats `metres` and `seconds` as concrete types with definitions,
rather than abstract type declarations that promise a definition somewhere.

`:- type metres.` in Mercury means "there is a type `metres` whose definition is
hidden from callers of this module." It is an abstract type declaration. Without a
corresponding concrete definition in the implementation section, Mercury reports the
error.

The pattern `:- type tag ---> tag_unit.` is the standard Mercury idiom for phantom
type tags. The `_unit` suffix signals that the constructor carries no data and is
never called.
