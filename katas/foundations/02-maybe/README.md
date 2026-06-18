# 02 — Maybe: threading optional values

**Concept:** `maybe(T)`, `yes(T)`/`no` constructors, `map_maybe`, chaining with a locally-defined `bind_maybe`, avoiding explicit if-then-else

**Not in the Mercury tutorial.** `maybe(T)` is Mercury's standard optional type. This kata
builds the idiom of threading optional values through a computation without pattern-matching
at every step.

---

## What you will build

A small config-reader. The program:
1. Defines a `config` record with fields `host :: maybe(string)` and `port :: maybe(int)`.
2. Reads a config from a hardcoded association list (simulating a parsed config file).
3. Uses `map_maybe` and a locally-defined `bind_maybe` to derive a formatted connection
   string, or `no` if either field is absent.

---

## Getting started

Create `config_reader.m` with this skeleton:

```mercury
:- module config_reader.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module assoc_list.
:- import_module list.
:- import_module maybe.
:- import_module pair.
:- import_module string.

% your types and predicates go here

main(!IO) :-
    % your main body goes here
    true.
```

---

## Steps

### 1. Define the types

```mercury
:- type config --->
    config(
        host :: maybe(string),
        port :: maybe(int)
    ).
```

### 2. Build a config from an association list

Write `lookup_config(Pairs, Config)` that extracts `maybe(string)` and `maybe(int)` from
a `list(pair(string, string))`. Use `assoc_list.search` (from `:- import_module assoc_list.`)
or a manual `list.member` search. Converting the port string to int: `string.to_int/2` is
`semidet` — wrap its result in `maybe`.

Hint: `( string.to_int(Str, N) -> yes(N) ; no )`.

### 3. Derive the connection string

Write:
```mercury
:- func connection_string(config) = maybe(string).
```

Without `maybe.map`:
```mercury
connection_string(Config) =
    ( Config^host = yes(H), Config^port = yes(P) ->
        yes(H ++ ":" ++ string.int_to_string(P))
    ;
        no
    ).
```

Now rewrite it using `bind_maybe`. The Mercury standard library does not export `maybe.bind`
in 22.01.8 — define it yourself in the implementation section:

```mercury
:- func bind_maybe(maybe(T), func(T) = maybe(U)) = maybe(U).
bind_maybe(no, _) = no.
bind_maybe(yes(X), F) = F(X).
```

Then use it:
```mercury
connection_string(Config) =
    bind_maybe(Config^host, (func(H) =
        map_maybe((func(P) = H ++ ":" ++ string.int_to_string(P)),
                  Config^port)
    )).
```

Both should produce the same result. Notice `bind_maybe` is the "flatMap" / "chain"
operation: it applies `F` only when the input is `yes(X)`, and the function `F` itself
returns a `maybe` — so no nested `yes(yes(...))` appears.

### 4. Main

Print the connection string if present, or `"No connection configured"` if absent. Use
pattern matching on the final `maybe(string)`.

---

## Checkpoint

- `mmc --make --grade asm_fast.par.gc.stseg config_reader` builds clean
- The `bind_maybe` version produces the same output as the explicit if-then-else version
- You can explain: when does `bind_maybe` return `no` without the inner function running?

## What's next

The `maybe` pattern recurs everywhere optional state appears. `07-exceptions` shows `io.res`
— which plays the same role as `maybe` but carries an error message in the failure case.
