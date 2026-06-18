# Puzzle: frequency histogram

**Primary skills:** `map(string, int)`, `list`, `string`, `io`, sorted output with relative bar lengths

**Why Mercury:** extends the `02-map` kata (word tally) into a complete program with output formatting. Demonstrates the full pipeline from IO through data processing to display.

## Prerequisites

- `katas/foundations/05-map` — `map(string, int)`, `foldl` accumulation patterns
- `katas/foundations/03-string` — `string.words`, `string.pad_right`, `string.duplicate_char`

---

## The problem

Read text from stdin. Count word frequencies. Display a sorted ASCII histogram where
each word's bar length is proportional to its frequency.

---

## Sample output

For input `"the cat sat on the mat the cat sat"`:

```
the  | ████████████████ (3)
cat  | ██████████ (2)
sat  | ██████████ (2)
on   | █████ (1)
mat  | █████ (1)
```

Bars are proportional: the most frequent word gets the full bar width (e.g., 20 chars),
others are scaled accordingly.

---

## Steps

### 1. Read all words from stdin

```mercury
io.read_file_as_string(io.stdin_stream, Res, !IO),
( Res = ok(Text) -> ... ).
Words = string.words(Text).
```

### 2. Count frequencies

```mercury
:- pred count_words(list(string)::in, map(string, int)::out) is det.
count_words(Words, Counts) :-
    list.foldl(
        (pred(W::in, M0::in, M::out) is det :-
            ( map.search(M0, W, C) -> map.set(W, C + 1, M0, M) ; map.set(W, 1, M0, M) )),
        Words, map.init, Counts).
```

Or use `map.det_update` / `map.get_or_default`.

### 3. Sort by frequency (descending)

```mercury
Pairs = map.to_assoc_list(Counts),
list.sort((pred(A-CA::in, B-CB::in, Order::out) is det :-
    compare(Order, CB, CA)),   % note: CB then CA for descending
    Pairs, Sorted).
```

### 4. Format the bars

Compute the maximum frequency. Scale each bar: `BarLen = MaxLen * Count // MaxCount`.
Build bar with `string.duplicate_char('█', BarLen)`.

Left-pad word labels to align bars:
```mercury
PadWidth = max word length in the list
Label = string.pad_right(Word, ' ', PadWidth)
```

---

## Extensions

- Read from a file (command-line argument)
- Case-insensitive (normalize to lowercase before counting)
- Filter out stop words ("the", "a", "an", "and", etc.)
- Count bigrams instead of words
