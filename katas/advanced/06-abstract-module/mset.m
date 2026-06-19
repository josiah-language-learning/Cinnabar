:- module mset.

% ---- Interface: what clients can see ----------------------------------------
%
% The type `mset(T)' (multiset) is declared here without constructors. Clients
% know the type exists and can store values of it, but cannot construct or
% deconstruct it directly. All operations go through the predicates below.

:- interface.
:- use_module list.   % use_module, not import_module: list types appear in our
                      % signatures but we do not re-export list's predicates to
                      % our callers. See katas/foundations/01-modules.

:- type mset(T).   % abstract — no constructors visible outside this module

% empty/1: produce an empty multiset.
:- pred empty(mset(T)::out) is det.

% insert/3: add one occurrence of X to the multiset.
:- pred insert(T::in, mset(T)::in, mset(T)::out) is det.

% count/3: how many times does X appear?
:- pred count(T::in, mset(T)::in, int::out) is det.

% remove/3: remove one occurrence of X. Fails if X is absent.
:- pred remove(T::in, mset(T)::in, mset(T)::out) is semidet.

% size/1: total element count (duplicates counted separately).
:- func size(mset(T)) = int.

% to_list/1: all elements as a list (order unspecified).
:- func to_list(mset(T)) = list.list(T).

% ---- Implementation: hidden from clients ------------------------------------
%
% The representation: a plain list, duplicates allowed.
% Clients cannot see this declaration — they only know the type `mset(T)' exists.

:- implementation.
:- import_module int.
:- import_module list.

:- type mset(T) == list(T).

% TODO: an empty multiset is an empty list.
empty([]).

% TODO: insert X at the front. The representation is list(T).
insert(_, Mset, Mset).

% TODO: use list.foldl to count occurrences of X.
% Hint: ( E = X -> Acc1 = Acc + 1 ; Acc1 = Acc )
count(_, _, 0).

% TODO: remove the first occurrence of X. Add a recursive clause for the tail.
% This stub only removes when X is at the head.
remove(X, [X | T], T).

% TODO: use list.length.
size(_) = 0.

% to_list: the representation already is a list. No work needed.
to_list(Mset) = Mset.
