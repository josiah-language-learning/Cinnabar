:- module unique_clobber.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module array.
:- import_module bool.
:- import_module int.
:- import_module list.

% BUG: make_array declares `array(int)::array_uo` as output — the array MUST
% be produced (uniquely initialized) in every branch. The else branch skips the
% initialization, leaving the array in inst `free`. This violates the uo mode.
:- pred make_array(bool::in, array(int)::array_uo) is det.
make_array(Flag, A) :-
    ( Flag = yes ->
        array.init(5, 0, A)   % A is initialized here
    ;
        true                  % BUG: A is never initialized — still free
    ).

main(!IO) :-
    make_array(yes, A),
    io.write_line(A, !IO).
