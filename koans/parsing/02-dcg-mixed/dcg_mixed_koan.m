:- module dcg_mixed_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module char.
:- import_module list.
:- import_module string.

% DCG rule: parses a sequence of word characters
:- pred word(list(char), list(char), list(char)).
:- mode word(out, in, out) is semidet.

word([C | Cs]) --> [C], { char.is_alpha(C) }, word_tail(Cs).

:- pred word_tail(list(char), list(char), list(char)).
:- mode word_tail(out, in, out) is det.

word_tail(Cs) -->
    ( [C], { char.is_alpha(C) } ->
        word_tail(Cs0), { Cs = [C | Cs0] }
    ;
        { Cs = [] }
    ).

% DCG rule: parses space-separated words
:- pred words(list(list(char)), list(char), list(char)).
:- mode words(out, in, out) is det.

words(Ws) -->
    ( word(W) ->
        ( [(' ')] ->
            words(Ws0), { Ws = [W | Ws0] }
        ;
            { Ws = [W] }
        )
    ;
        { Ws = [] }
    ).

% BUG: words is a DCG rule (it expands to words/3), but this call
% uses it as if it has only 2 arguments.
:- pred count_words(list(char)::in, int::out) is det.
count_words(Input, Count) :-
    words(Ws, Input),   % ERROR: words/2 does not exist — it needs 3 args: words(Ws, Input, _)
    list.length(Ws, Count).

main(!IO) :-
    Input = string.to_char_list("hello world foo"),
    count_words(Input, N),
    io.format("Word count: %d\n", [i(N)], !IO).
