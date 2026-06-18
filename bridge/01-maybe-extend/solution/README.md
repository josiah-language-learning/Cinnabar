# Solution notes

## Task 1: `timeout_or_default`

The simplest form — pattern-match directly, no `maybe.map` needed:

```mercury
:- func timeout_or_default(config) = int.
timeout_or_default(Config) =
    ( Config^timeout = yes(T) -> T ; 30 ).
```

You could also write it with `maybe.det_default`:
```mercury
timeout_or_default(Config) = maybe.det_default(30, Config^timeout).
```

## Task 2: port validation

The key decision: where does validation happen? Two options:

**Option A** — validate in `lookup_config` (recommended):
Validation is part of parsing. A port string that is out of range is treated the same
as a port string that does not parse — both produce `no`.

**Option B** — validate in `connection_string`:
The config stores the raw parsed int, and `connection_string` rejects out-of-range values.
This separates "did we find a port?" from "is the port valid?" — useful if you want to
report the invalid value to the user ("port 99999 is out of range").

Neither is always correct. The right choice depends on whether you need to distinguish
"missing" from "invalid" in your error messages.

## Task 3: `url_string` vs `connection_string`

Both functions have the same `bind_maybe` shape. Notice you can factor the host/port
extraction into a helper (using `bind_maybe` and `map_maybe` from the implementation
section of `config_reader.m`):

```mercury
:- func host_and_port(config) = maybe({string, int}).
host_and_port(Config) =
    bind_maybe(Config^host, (func(H) =
        map_maybe((func(P) = {H, P}), Config^port)
    )).
```

Then both functions use it:
```mercury
connection_string(C) = map_maybe((func({H, P}) = H ++ ":" ++ int_to_string(P)),
                                  host_and_port(C)).
url_string(C) = map_maybe((func({H, P}) = "http://" ++ H ++ ":" ++ int_to_string(P)),
                           host_and_port(C)).
```

This is the general pattern: extract shared structure into a helper, then map different
formatting functions over the same `maybe` value.
