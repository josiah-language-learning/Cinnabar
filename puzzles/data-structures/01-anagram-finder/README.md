# Puzzle: Anagram finder

**Primary skills:** `map(K, V)`, `string`, `list.sort`, grouping by derived key

**Why Mercury:** the `map` module makes the grouping pattern — sort each word's letters,
use that as a key, accumulate same-key words into a list — concise and natural.

## Prerequisites

- `katas/foundations/05-map` — `map(K, V)`, `map.search`, `map.set`, `map.values`
- `katas/foundations/03-string` — `string.to_char_list`, `string.from_char_list`, `string.to_lower`

---

## The problem

Given a list of words, group them into anagram families. Two words are anagrams if they
contain exactly the same letters (with the same frequencies).

Input: `list(string)` of words
Output: `list(list(string))` — each inner list is a group of anagrams

---

## Approach

A word's *canonical form* is its letters sorted alphabetically. Two words are anagrams
iff they have the same canonical form.

```mercury
:- func canonical(string) = string.
canonical(Word) = string.from_char_list(Sorted) :-
    Chars = string.to_char_list(string.to_lower(Word)),
    list.sort(Chars, Sorted).
```

Then group by canonical form using a `map(string, list(string))`:

```mercury
:- pred group_anagrams(list(string)::in, list(list(string))::out) is det.
group_anagrams(Words, Groups) :-
    list.foldl(insert_word, Words, map.init, GroupMap),
    map.values(GroupMap, Groups).

:- pred insert_word(string::in,
                    map(string, list(string))::in,
                    map(string, list(string))::out) is det.
insert_word(Word, !Map) :-
    Key = canonical(Word),
    ( map.search(!.Map, Key, Existing) ->
        map.set(Key, [Word | Existing], !Map)
    ;
        map.set(Key, [Word], !Map)
    ).
```

---

## What to observe

`map.values` returns values in key order — the groups are ordered by their canonical form.
If you want the original input order of first occurrence, you need to track insertion order
separately (e.g., use a `map(string, pair(int, list(string)))` with an insertion counter).

---

## Sample input

```mercury
Words = ["eat", "tea", "tan", "ate", "nat", "bat"].
```

Expected output (in some order):
```
["eat", "tea", "ate"]
["tan", "nat"]
["bat"]
```

---

## Extensions

- Sort each group so the output is deterministic
- Read words from stdin, one per line
- Find the largest anagram family in `/usr/share/dict/words`
