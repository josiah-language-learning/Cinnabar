:- module config_reader.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module assoc_list.
:- import_module list.
:- import_module maybe.
:- import_module pair.
:- import_module string.

:- type config --->
    config(
        host :: maybe(string),
        port :: maybe(int)
    ).

:- pred lookup_config(assoc_list(string, string)::in, config::out) is det.
lookup_config(Pairs, config(Host, Port)) :-
    ( assoc_list.search(Pairs, "host", H) -> Host = yes(H) ; Host = no ),
    ( assoc_list.search(Pairs, "port", S), string.to_int(S, N) ->
        Port = yes(N)
    ;
        Port = no
    ).

:- func bind_maybe(maybe(T), func(T) = maybe(U)) = maybe(U).
bind_maybe(no, _) = no.
bind_maybe(yes(X), F) = F(X).

:- func connection_string(config) = maybe(string).
connection_string(Config) =
    bind_maybe(Config^host, (func(H) =
        map_maybe((func(P) = H ++ ":" ++ string.int_to_string(P)),
                  Config^port)
    )).

main(!IO) :-
    Pairs1 = ["host" - "db.example.com", "port" - "5432"],
    lookup_config(Pairs1, C1),
    print_connection(C1, !IO),

    Pairs2 = ["host" - "localhost"],
    lookup_config(Pairs2, C2),
    print_connection(C2, !IO),

    Pairs3 = ([] : assoc_list(string, string)),
    lookup_config(Pairs3, C3),
    print_connection(C3, !IO).

:- pred print_connection(config::in, io::di, io::uo) is det.
print_connection(Config, !IO) :-
    ( connection_string(Config) = yes(S) ->
        io.format("Connection: %s\n", [s(S)], !IO)
    ;
        io.write_string("No connection configured\n", !IO)
    ).
