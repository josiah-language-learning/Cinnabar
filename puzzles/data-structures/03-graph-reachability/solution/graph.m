:- module graph.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module list.
:- import_module map.
:- import_module pair.
:- import_module set.
:- import_module solutions.
:- import_module string.

:- type node == string.
:- type graph == map(node, list(node)).

:- func example_graph = graph.
example_graph = map.from_assoc_list([
    "a" - ["b", "c"],
    "b" - ["d"],
    "c" - ["b", "e"],
    "d" - ["a"],
    "e" - []
]).

% Approach 1: manual visited set
:- pred reachable_manual(graph::in, node::in, set(node)::in, set(node)::out) is det.
reachable_manual(Graph, Start, Visited0, Visited) :-
    ( set.member(Start, Visited0) ->
        Visited = Visited0
    ;
        Visited1 = set.insert(Visited0, Start),
        ( map.search(Graph, Start, Neighbors) ->
            list.foldl(reachable_manual(Graph), Neighbors, Visited1, Visited)
        ;
            Visited = Visited1
        )
    ).

% Approach 2: loop_check (requires C grade / standard grade with tabling support)
:- pred reachable_node(graph::in, node::in, node::out) is nondet.
:- pragma loop_check(reachable_node/3).
reachable_node(_, Start, Start).
reachable_node(Graph, Start, Node) :-
    map.search(Graph, Start, Neighbors),
    list.member(Next, Neighbors),
    reachable_node(Graph, Next, Node).

main(!IO) :-
    G = example_graph,
    % Manual approach
    reachable_manual(G, "a", set.init, Reachable1),
    io.write_string("Manual reachability from a: ", !IO),
    io.write_line(Reachable1, !IO),
    % Tabling approach
    solutions(reachable_node(G, "a"), ReachList),
    Reachable2 = set.from_list(ReachList),
    io.write_string("Tabling reachability from a: ", !IO),
    io.write_line(Reachable2, !IO).
