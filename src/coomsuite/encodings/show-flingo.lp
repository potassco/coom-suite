#show .

#show include(X) : include(X), type(X,T), part(T), X != "root".

#show value(X,V) : value(X,V), type(X,T), discrete(T).
&show { X : type(X,T), integer(T) }.

% #show associate/3.

#show associate((X,X'),N,I) : associate((X,X'),N,I), not association_match(X,N,_).
#show associate((X,X'),N,I,N',I') : associate((X,X'),N,I), associate((X',X),N',I'), association_match(X,N,N'), X < X'.
