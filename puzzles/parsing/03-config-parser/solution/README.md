# Config parser solution notes

## Section tracking with a fold accumulator

The parser needs to know the "current section" while processing lines. Thread it as an
accumulator:

```mercury
:- pred parse_lines(list(string)::in, string::in,
                    map(string, map(string, string))::in,
                    map(string, map(string, string))::out) is det.
parse_lines([], _, M, M).
parse_lines([Line | Lines], Section, M0, M) :-
    ( is_section_header(Line, NewSection) ->
        parse_lines(Lines, NewSection, M0, M)
    ; is_key_value(Line, Key, Value) ->
        ( map.search(M0, Section, SectionMap0) ->
            map.set(Key, Value, SectionMap0, SectionMap1)
        ;
            map.from_assoc_list([Key - Value], SectionMap1)
        ),
        map.set(Section, SectionMap1, M0, M1),
        parse_lines(Lines, Section, M1, M)
    ;
        parse_lines(Lines, Section, M0, M)  % blank / comment / unrecognized
    ).
```

## Section header detection

```mercury
:- pred is_section_header(string::in, string::out) is semidet.
is_section_header(Line, Section) :-
    string.prefix(Line, "["),
    string.suffix(Line, "]"),
    string.between(Line, 1, string.length(Line) - 1, Section).
```

## The abstract type payoff

With an abstract `config` type, the caller does:
```mercury
get(Config, "database", "port", "5432")
```

and never knows whether the internals are a map-of-maps, a flat map, or a lookup table.
This is the abstraction doing its job.
