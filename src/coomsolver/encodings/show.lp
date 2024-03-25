% Show statements
#show .
#show instance(I,S) : instance(I,S), structure(S).

#show val(X,V) : val(X,V), instance(X,Type), option(Type,_).
#show val(X,V) : val(X,V), instance(X,Attr), attr_value(_,_,Attr,_).