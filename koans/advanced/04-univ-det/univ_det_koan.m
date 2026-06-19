:- module univ_det_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module univ.
:- import_module string.

% BUG: univ_to_type/2 is semidet — it can fail if the univ value
% does not hold the requested type at runtime.
% Declaring extract_int as `det` while calling a semidet predicate
% propagates the can-fail property upward: the declaration is rejected.
:- pred extract_int(univ::in, int::out) is det.
extract_int(U, N) :-
    univ_to_type(U, N).

main(!IO) :-
    type_to_univ(42, U),
    extract_int(U, N),
    io.write_int(N, !IO),
    io.nl(!IO).
