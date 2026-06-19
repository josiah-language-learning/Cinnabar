:- module map_io_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module list.
:- import_module string.

% Print each string in a list using list.map.
%
% BUG: list.map expects a pure pred(in, out) — it has no IO threading.
% The lambda closes over !IO from the outer scope, but !IO is a unique
% (di/uo) state variable.  A unique value cannot be shared across multiple
% lambda invocations.  Use list.foldl to thread !IO through each call.
:- pred print_all(list(string)::in, io::di, io::uo) is det.
print_all(Strs, !IO) :-
    list.map(
        (pred(S::in, Echoed::out) is det :-
            Echoed = S,
            io.write_string(S ++ "\n", !IO)),   % BUG: captures unique !IO
        Strs, _Echoed).

main(!IO) :-
    print_all(["alpha", "beta", "gamma"], !IO).
