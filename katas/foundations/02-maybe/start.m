:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module maybe.
:- import_module string.

% The maybe module exports map_maybe/2 in 22.01.8, so we use distinct names
% for the student's implementations to avoid overloading conflicts.
:- func bind_maybe(maybe(T), func(T) = maybe(U)) = maybe(U).
bind_maybe(no, _) = no.
bind_maybe(yes(_X), _F) = no.   % stub: apply _F to _X

:- func my_map_maybe(func(T) = U, maybe(T)) = maybe(U).
my_map_maybe(_, no) = no.
my_map_maybe(_F, yes(_X)) = no.    % stub: apply _F to _X, wrap in yes(...)

% A config type assembled from three strings.
:- type config ---> config(host :: string, port :: int, debug :: bool).

% Succeed only if S parses as an integer in 1..65535.
:- pred parse_port(string::in, int::out) is semidet.
parse_port(_S, 0) :- fail.  % stub

% Build a maybe(config) from raw strings; no if the port is invalid.
:- func load_config(string, string, string) = maybe(config).
load_config(_Host, _PortStr, _DebugStr) = no.  % stub

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    check("bind: no propagates",
        ( bind_maybe(maybe.no, func(X) = maybe.yes(X)) = maybe.no -> yes ; no ), !IO),
    check("bind: yes applies f",
        ( bind_maybe(maybe.yes(3), func(X) = maybe.yes(X + 1)) = maybe.yes(4) -> yes ; no ), !IO),
    check("bind: chain short-circuits on no",
        ( bind_maybe(maybe.yes(2), func(X) = ( X > 5 -> maybe.yes(X) ; maybe.no )) = maybe.no
          -> yes ; no ), !IO),
    check("bind: chain reaches yes",
        ( bind_maybe(maybe.yes(10), func(X) = ( X > 5 -> maybe.yes(X * 2) ; maybe.no )) = maybe.yes(20)
          -> yes ; no ), !IO),
    check("my_map: no stays no",
        ( my_map_maybe(func(X) = X + 1, maybe.no) = maybe.no -> yes ; no ), !IO),
    check("my_map: yes applies f",
        ( my_map_maybe(func(X) = X * 2, maybe.yes(5)) = maybe.yes(10) -> yes ; no ), !IO),
    check("load_config: valid port",
        ( load_config("localhost", "8080", "no") = maybe.yes(_) -> yes ; no ), !IO),
    check("load_config: bad port gives no",
        ( load_config("localhost", "notaport", "no") = maybe.no -> yes ; no ), !IO).
