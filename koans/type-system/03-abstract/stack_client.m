:- module stack_client.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module stack.

:- pred drain_stack(stack(int)::in, io::di, io::uo) is det.
drain_stack(S, !IO) :-
    % BUG: pattern-matching on stack_node/2, which is not exported by stack.m
    ( S = stack_node(Top, Rest) ->
        io.format("%d\n", [i(Top)], !IO),
        drain_stack(Rest, !IO)
    ;
        io.write_string("(empty)\n", !IO)
    ).

main(!IO) :-
    S = stack.push(3, stack.push(2, stack.push(1, stack.empty))),
    drain_stack(S, !IO).
