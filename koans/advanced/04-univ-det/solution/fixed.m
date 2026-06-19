:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module univ.
:- import_module string.

% FIX: declare extract_int as semidet to match univ_to_type's determinism.
% The caller (main) must handle the failure case explicitly.
:- pred extract_int(univ::in, int::out) is semidet.
extract_int(U, N) :-
    univ_to_type(U, N).

main(!IO) :-
    type_to_univ(42, U),
    ( extract_int(U, N) ->
        io.write_int(N, !IO),
        io.nl(!IO)
    ;
        io.write_string("not an int\n", !IO)
    ).
