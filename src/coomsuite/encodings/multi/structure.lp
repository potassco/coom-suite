% Always include root object
include("root").

#program new_object(name,type,parent,index,set).

% Generate include predicates for objects
{ include(name) : type(name,_) }.

% % Always include minimal number of objects
% % Commented out because we wanted to include no optimizations currently
% % include(X) :- feature(C,_,T,Min,_), type(X,T), index(X,I), I < Min,
% %                parent(X,P), include(P), type(P,C).

% Do not include an object if its parent is not included
:- include(name), parent(name,P), not include(P).

% Indices in ascending order
:-  include(name), set(set,name ), index(name,index  ), index > 0,
not include(X'  ), set(set,X'   ), index(X'  ,index-1), constraint((set,_),_).
