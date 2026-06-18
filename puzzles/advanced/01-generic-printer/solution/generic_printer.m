:- module generic_printer.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module deconstruct.
:- import_module int.
:- import_module list.
:- import_module maybe.
:- import_module string.
:- import_module univ.

%---------------------------------------------------------------------------%
% The printer

:- pred pretty(univ::in, int::in, io::di, io::uo) is det.
pretty(U, Depth, !IO) :-
    deconstruct(univ_value(U), canonicalize, Functor, _Arity, Args),
    Indent = string.duplicate_char(' ', Depth * 2),
    (
        Args = [],
        io.format("%s%s\n", [s(Indent), s(Functor)], !IO)
    ;
        Args = [_ | _],
        io.format("%s%s(\n", [s(Indent), s(Functor)], !IO),
        list.foldl(pretty_arg(Depth + 1), Args, !IO),
        io.format("%s)\n", [s(Indent)], !IO)
    ).

:- pred pretty_arg(int::in, univ::in, io::di, io::uo) is det.
pretty_arg(Depth, U, !IO) :-
    pretty(U, Depth, !IO).

:- pred pretty_any(T::in, io::di, io::uo) is det.
pretty_any(Value, !IO) :-
    pretty(univ(Value), 0, !IO).

%---------------------------------------------------------------------------%
% Test types

:- type tree(T) ---> leaf ; node(tree(T), T, tree(T)).

%---------------------------------------------------------------------------%

main(!IO) :-
    io.write_string("--- list [1,2,3] ---\n", !IO),
    pretty_any([1, 2, 3], !IO),

    io.write_string("\n--- tree ---\n", !IO),
    Tree = node(node(leaf, 1, leaf), 2, node(leaf, 3, leaf)),
    pretty_any(Tree, !IO),

    io.write_string("\n--- yes(yes(42)) ---\n", !IO),
    pretty_any(yes(yes(42)), !IO),

    io.write_string("\n--- plain int 99 ---\n", !IO),
    pretty_any(99, !IO),

    io.write_string("\n--- string \"hello\" ---\n", !IO),
    pretty_any("hello", !IO).
