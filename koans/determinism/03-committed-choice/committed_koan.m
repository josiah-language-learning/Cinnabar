:- module committed_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module maybe.
:- import_module string.

:- pred generate_option(int::out) is cc_nondet.
generate_option(1).
generate_option(2).
generate_option(3).

% BUG: cc_nondet called from semidet context.
% cc_nondet requires det or cc_multi calling context.
:- pred find_first(int::out) is semidet.
find_first(N) :-
    generate_option(N),   % DETERMINISM ERROR: cc_nondet in semidet context
    N > 0.

main(!IO) :-
    ( find_first(N) ->
        io.format("Found: %d\n", [i(N)], !IO)
    ;
        io.write_string("Not found\n", !IO)
    ).
