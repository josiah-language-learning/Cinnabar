:- module phantom_con_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

% Attempting to create phantom type tags for a parameterised type.
% BUG: :- type metres. declares an ABSTRACT type (no definition visible here),
%      not an empty concrete type. Mercury expects a definition in the
%      implementation section that never comes.
:- type metres.
:- type seconds.

:- type speed(Dist, Time) ---> speed(float).
:- func make_speed(float) = speed(metres, seconds).

:- implementation.

make_speed(V) = speed(V).

main(!IO) :-
    _S = make_speed(5.0),
    io.write_string("ok\n", !IO).
