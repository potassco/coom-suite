#show .

#show include(X) : include(X), type(X,T), part(T), X != "root".

#show value(X,V) : value(X,V), type(X,T), discrete(T,(str;bool)).
&show { X : type(X,T), discrete(T,int) }.
&show { X : type(X,T), numeric(T,int) }.
