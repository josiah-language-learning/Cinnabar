:- module existential_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module int.
:- import_module list.
:- import_module string.

:- type tagged
    --->    some [T] tagged(string, T).

:- pred tag(string::in, T::in, tagged::out) is det.
tag(Label, Value, 'new tagged'(Label, Value)).

:- pred show_label(tagged::in, io::di, io::uo) is det.
show_label(tagged(Label, _), !IO) :-
    io.format("label: %s\n", [s(Label)], !IO).

main(!IO) :-
    tag("count", 42, T1),
    tag("name", "mercury", T2),
    show_label(T1, !IO),
    show_label(T2, !IO).
