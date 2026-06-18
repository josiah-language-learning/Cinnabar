# Puzzle: structured config parser

**Primary skills:** `parsing_utils`, `map`, `maybe`, abstract types, section headers

**Why Mercury:** extends `katas/parsing/03-parsing-utils` with section headers and an
abstract `config` output type that hides the map implementation.

## Prerequisites

- `katas/parsing/03-parsing-utils` — `parsing_utils` combinator library
- `katas/type-system/03-abstract-types` — abstract type declarations and exported interfaces

---

## The problem

Parse a config file with sections and key-value pairs:

```ini
[database]
host = localhost
port = 5432

[server]
host = 0.0.0.0
port = 8080
debug = true
```

Output: an abstract `config` type with operations:
```mercury
:- type config.
:- func get(config, string, string, string) = maybe(string).
% get(Config, Section, Key, Default) = value, or no if missing
```

---

## The section format

```
[section-name]
key = value
key = value
```

Lines starting with `[` are section headers. Lines containing `=` are key-value pairs
in the current section. Blank lines and lines starting with `#` are ignored.

---

## Representation

Internally: `map(string, map(string, string))` — section name → (key → value).

```mercury
:- type config ---> config(map(string, map(string, string))).
```

Export as an abstract type in the interface section.

---

## Parsing approach

Use `parsing_utils` or split-by-line + per-line parsing:

```mercury
:- pred parse_config(string::in, config::out) is det.
parse_config(Input, Config) :-
    Lines = string.split_at_char('\n', Input),
    parse_lines(Lines, "", map.init, SectionMap),
    Config = config(SectionMap).
```

Process lines with a fold that tracks the current section:

```mercury
:- pred parse_lines(list(string)::in, string::in,
                    map(string, map(string, string))::in,
                    map(string, map(string, string))::out) is det.
```

---

## What to observe

The abstract type prevents callers from pattern-matching on `config(...)` directly.
The `get/4` function is the only way to extract values. If the internal representation
changes from a map-of-maps to a flat map with `"section.key"` keys, no caller code changes.

---

## Extensions

- Support `#` and `;` comments
- Support multi-line values with `\` continuation
- Support `include = other_file.ini` directives
- Write a config serializer (back to ini format)
