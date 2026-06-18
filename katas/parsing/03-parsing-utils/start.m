:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module char.
:- import_module list.
:- import_module map.
:- import_module maybe.
:- import_module parsing_utils.
:- import_module string.
:- import_module unit.

% parsing_utils API quick-reference (Mercury 22.01.8):
%   new_src_and_ps(Input::in, Src::out, PS::out) is det
%   next_char(Src::in, Char::out, PS::in, PS::out) is semidet
%   skip_whitespace(Src::in, PS::in, PS::out) is det
%   whitespace(Src::in, PS::in, PS::out) is det
%   match_string(String::in, Src::in, PS::in, PS::out) is semidet
%   identifier(InitialChars::in, FollowChars::in, Src::in,
%               Id::out, PS::in, PS::out) is semidet
%   punct(String::in, Src::in, Dummy::out, PS::in, PS::out) is semidet

:- type pair == {string, string}.

% parse_ident: one or more lowercase alpha chars.
:- pred parse_ident(src::in, string::out, ps::in, ps::out) is semidet.
parse_ident(Src, Id, !PS) :-
    parsing_utils.identifier("abcdefghijklmnopqrstuvwxyz",
                              "abcdefghijklmnopqrstuvwxyz0123456789_",
                              Src, Id, !PS).

% parse_value: chars up to end of input or newline.
:- pred parse_value(src::in, string::out, ps::in, ps::out) is semidet.
parse_value(Src, Val, !PS) :-
    parsing_utils.identifier("abcdefghijklmnopqrstuvwxyz0123456789_",
                              "abcdefghijklmnopqrstuvwxyz0123456789_",
                              Src, Val, !PS).

% parse_pair: key=value
:- pred parse_pair(src::in, pair::out, ps::in, ps::out) is semidet.
parse_pair(Src, {Key, Val}, !PS) :-
    parse_ident(Src, Key, !PS),
    parsing_utils.punct("=", Src, _, !PS),
    parse_value(Src, Val, !PS).

% parse_config: single key=value (extend to multi-line as an exercise).
:- pred parse_config(src::in, map(string,string)::out, ps::in, ps::out) is semidet.
parse_config(Src, Config, !PS) :-
    parse_pair(Src, {K, V}, !PS),
    Config = map.singleton(K, V).

:- pred run_pair(string::in, maybe(pair)::out) is det.
run_pair(Input, Result) :-
    parsing_utils.new_src_and_ps(Input, Src, PS0),
    ( parse_pair(Src, P, PS0, _) ->
        Result = yes(P)
    ;
        Result = no
    ).

:- pred run_config(string::in, maybe(map(string,string))::out) is det.
run_config(Input, Result) :-
    parsing_utils.new_src_and_ps(Input, Src, PS0),
    ( parse_config(Src, Cfg, PS0, _) ->
        Result = yes(Cfg)
    ;
        Result = no
    ).

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    run_pair("host=localhost", R1),
    check("parse host=localhost",
          ( R1 = yes({"host","localhost"}) -> yes ; no ), !IO),
    run_pair("port=8080", R2),
    check("parse port=8080",
          ( R2 = yes({"port","8080"}) -> yes ; no ), !IO),
    run_config("host=localhost", R3),
    ( R3 = yes(Cfg) ->
        check("config has host",
              ( map.lookup(Cfg, "host") = "localhost" -> yes ; no ), !IO)
    ;
        check("config has host", no, !IO)
    ).
