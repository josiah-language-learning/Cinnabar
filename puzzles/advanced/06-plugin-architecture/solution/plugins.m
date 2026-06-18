:- module plugins.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module string.

%---------------------------------------------------------------------------%
% A plugin is a named string transformer.
% The behavior is stored as a first-class function closure, which gives the
% same open-world property as existential types: new plugins are created by
% calling mk_* without changing the core system.

:- type plugin
    --->    plugin(
                pname  :: string,
                papply :: func(string) = string
            ).

%---------------------------------------------------------------------------%
% Concrete plugin constructors

:- func mk_upper = plugin.
mk_upper = plugin("upper", string.to_upper).

:- func mk_repeat(int) = plugin.
mk_repeat(N) = plugin(
    "repeat(" ++ string.int_to_string(N) ++ ")",
    func(S) = repeat_str(N, S)).

:- func mk_prepend(string) = plugin.
mk_prepend(P) = plugin(
    "prepend(\"" ++ P ++ "\")",
    func(S) = P ++ S).

:- func repeat_str(int, string) = string.
repeat_str(N, S) = ( N =< 0 -> "" ; S ++ repeat_str(N - 1, S) ).

%---------------------------------------------------------------------------%
% Core system: run a pipeline, threading the string through each plugin

:- pred run_pipeline(list(plugin)::in, string::in, io::di, io::uo) is det.
run_pipeline([], Final, !IO) :-
    io.format("  => final: \"%s\"\n", [s(Final)], !IO).
run_pipeline([P | Rest], Input, !IO) :-
    Output = (P ^ papply)(Input),
    io.format("  [%s] \"%s\" => \"%s\"\n",
        [s(P ^ pname), s(Input), s(Output)], !IO),
    run_pipeline(Rest, Output, !IO).

%---------------------------------------------------------------------------%

main(!IO) :-
    io.write_string("=== formatter plugin pipeline ===\n", !IO),
    Pipeline = [
        mk_prepend(">> "),
        mk_upper,
        mk_repeat(2),
        mk_prepend("**")
    ],
    run_pipeline(Pipeline, "hello", !IO),

    io.nl(!IO),
    io.write_string("=== single-plugin runs ===\n", !IO),
    Plugins = [mk_upper, mk_repeat(3), mk_prepend("x: ")],
    list.foldl(
        (pred(P::in, !.IO::di, !:IO::uo) is det :-
            io.format("  %s(\"test\") = \"%s\"\n",
                [s(P ^ pname), s((P ^ papply)("test"))], !IO)),
        Plugins, !IO).
