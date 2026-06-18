# Frequency histogram solution notes

## The pipeline

```
stdin → string → word list → frequency map → sorted pairs → formatted output
```

Each step is a pure transformation. Only the first (read) and last (print) touch IO.

## `map.to_assoc_list` + sort

`map.to_assoc_list` returns pairs in key order (alphabetical for strings). To sort by
value (frequency descending), we need `list.sort` with a custom comparator.

Note: `list.sort` is stable. The tiebreaker for equal frequencies is the key order
(alphabetical), giving a deterministic output.

## Proportional bar length

`BarLen = MaxBarLen * Count // MaxCount` scales each count proportionally. For the most
frequent word: `MaxBarLen * MaxCount // MaxCount = MaxBarLen` (full bar). For a word
with half the frequency: `MaxBarLen // 2`.

Integer division rounds down — words with very low frequency relative to the max will
get a bar of length 0. You can add a minimum of 1 if desired.
