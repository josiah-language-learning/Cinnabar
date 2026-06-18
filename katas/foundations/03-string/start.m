:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module string.

% wrap: re-wrap Text so no line exceeds Width codepoints; break only on spaces.
:- func wrap(string, int) = string.
wrap(_Text, _Width) = "".   % stub

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % The UTF-8 gotcha: length counts code units, not codepoints.
    check("string.count_codepoints(\"café\") = 4",
        ( string.count_codepoints("café") = 4 -> yes ; no ), !IO),

    % Wrapping empty string is a no-op.
    check("wrap empty",
        ( wrap("", 10) = "" -> yes ; no ), !IO),

    % A word shorter than the width fits on one line.
    check("wrap single short word",
        ( wrap("hello", 10) = "hello" -> yes ; no ), !IO),

    % Two words that exceed the width must be split.
    check("wrap two words that must break",
        ( wrap("hello world", 7) = "hello\nworld" -> yes ; no ), !IO),

    % Wrapping must not lose words.
    Text = "The quick brown fox jumps over the lazy dog",
    list.length(string.words(Text), TextWC),
    check("wrap preserves word count at 20",
        ( list.length(string.words(wrap(Text, 20)), WC20),
          WC20 = TextWC -> yes ; no ), !IO),
    check("wrap preserves word count at 10",
        ( list.length(string.words(wrap(Text, 10)), WC10),
          WC10 = TextWC -> yes ; no ), !IO).
